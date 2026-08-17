#!/usr/bin/env python3
"""Stop hook: mirror each response that carries a code block or a formula into a
VS Code markdown preview tab, one document per session.

The Claude Code VS Code extension prints fenced blocks unhighlighted and leaves
`$$…$$` as literal text. Re-emitting the response as markdown that VS Code opens
as a preview restores both: blocks get syntax highlighting and mermaid ones turn
into diagrams (built in since VS Code 1.121), and math goes through the
preview's KaTeX pass (`markdown.math.enabled`, on by default).

The response body is copied verbatim, so prose, tables, and lists around the
blocks keep the shape they had in the chat. Responses with nothing to render are
skipped, so a one-line acknowledgement does not open a tab.

Each response is prepended, so the newest one sits at the top of the tab and
earlier ones stay reachable below. A turn already carrying its uuid marker in the
document is skipped, which keeps a re-fired hook from duplicating a section.

Generated documents live in ~/.claude/response-preview/, deliberately apart from
this tracked script. Rendering relies on `workbench.editorAssociations` mapping
that directory's .md files to `vscode.markdown.preview.editor`; without it they
open as plain text.
"""

import collections
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import time

OUT_DIR = os.path.join(os.path.expanduser("~"), ".claude", "response-preview")
LOG_FILE = os.path.join(OUT_DIR, "debug.log")
DOC_TTL = 7 * 24 * 60 * 60
FENCE_OPEN = re.compile(r"^(?P<indent> {0,3})(?P<fence>`{3,}|~{3,})(?P<info>[^`]*)$")
MATH_BLOCK = re.compile(r"\$\$.+?\$\$", re.DOTALL)

Response = collections.namedtuple("Response", "text uuid timestamp title")


def log(message):
    try:
        os.makedirs(OUT_DIR, exist_ok=True)
        if os.path.exists(LOG_FILE) and os.path.getsize(LOG_FILE) > 200_000:
            os.remove(LOG_FILE)
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write("%s  %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), message))
    except OSError:
        pass


def read_records(transcript_path):
    try:
        with open(transcript_path, encoding="utf-8") as f:
            lines = f.readlines()
    except OSError:
        return []
    records = []
    for line in lines:
        try:
            records.append(json.loads(line))
        except ValueError:
            continue
    return records


def is_tool_result(record):
    content = record.get("message", {}).get("content")
    if not isinstance(content, list) or not content:
        return False
    return all(isinstance(p, dict) and p.get("type") == "tool_result" for p in content)


def text_of(record):
    content = record.get("message", {}).get("content")
    if not isinstance(content, list):
        return ""
    return "\n".join(
        part.get("text", "")
        for part in content
        if isinstance(part, dict) and part.get("type") == "text"
    ).strip()


def session_title(records):
    for record in reversed(records):
        if record.get("type") == "ai-title":
            title = (record.get("aiTitle") or "").strip()
            if title:
                return title
    return ""


def final_response(records):
    """The response that just ended, or None if it has not been flushed yet.

    Stop fires before the transcript is guaranteed to be on disk. Hitting a real
    user turn while walking backwards means this response has not landed, so the
    caller must retry rather than pick up the previous turn's text.
    """
    for record in reversed(records):
        kind = record.get("type")
        if kind == "assistant":
            text = text_of(record)
            if text:
                return Response(text, record.get("uuid") or "", record.get("timestamp") or "",
                                session_title(records))
        elif kind == "user" and not is_tool_result(record):
            return None
    return None


def await_final_response(transcript_path, timeout=10.0, interval=0.2):
    deadline = time.time() + timeout
    while True:
        response = final_response(read_records(transcript_path))
        if response is not None:
            return response
        if time.time() >= deadline:
            return None
        time.sleep(interval)


def renderables(text):
    """Labels for the parts of `text` the chat pane cannot draw, in order.

    Fenced blocks are scanned line by line rather than with one regex so that a
    block quoting a shorter fence inside a longer one counts once: the closing
    fence must repeat the opening character at least as many times. Math is
    searched only in what is left after the fences are removed, so a `$$` in a
    shell sample does not pass for a formula.
    """
    labels = []
    prose = []
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        line = lines[i]
        i += 1
        opening = FENCE_OPEN.match(line)
        if not opening:
            prose.append(line)
            continue
        fence = opening.group("fence")
        closing = re.compile(r"^ {0,3}%s{%d,}[ \t]*$" % (re.escape(fence[0]), len(fence)))
        body = []
        while i < len(lines) and not closing.match(lines[i]):
            body.append(lines[i])
            i += 1
        i += 1
        if any(line.strip() for line in body):
            info = opening.group("info").strip()
            labels.append(info.split()[0] if info else "code")
    if MATH_BLOCK.search("\n".join(prose)):
        labels.append("math")
    return labels


def local_time(stamp):
    try:
        parsed = datetime.datetime.fromisoformat(stamp.replace("Z", "+00:00"))
    except (AttributeError, ValueError):
        return time.strftime("%m-%d %H:%M")
    return parsed.astimezone().strftime("%m-%d %H:%M")


def section_for(response):
    return "<!-- turn:%s -->\n## %s\n\n%s" % (response.uuid, local_time(response.timestamp),
                                              response.text.strip("\n"))


def document_path(session_id):
    return os.path.join(OUT_DIR, "%s.md" % (session_id[:8] or "unknown"))


def prepend_section(path, response, section):
    """Put `section` at the top of the document. False if the turn is already there."""
    try:
        with open(path, encoding="utf-8") as f:
            existing = f.read()
    except OSError:
        existing = ""
    if response.uuid and "<!-- turn:%s -->" % response.uuid in existing:
        return False
    body = existing.split("\n", 1)[-1] if existing.startswith("# ") else existing
    parts = ["# %s" % (response.title or "Claude Code session"), section]
    if body.strip():
        parts += ["---", body.strip("\n")]
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n\n".join(parts) + "\n")
    return True


def prune_documents(keep):
    cutoff = time.time() - DOC_TTL
    for name in os.listdir(OUT_DIR):
        path = os.path.join(OUT_DIR, name)
        if not name.endswith(".md") or path == keep:
            continue
        try:
            if os.path.getmtime(path) < cutoff:
                os.remove(path)
        except OSError:
            pass


def main():
    entrypoint = os.environ.get("CLAUDE_CODE_ENTRYPOINT")
    if entrypoint != "claude-vscode":
        log("skip: entrypoint=%s" % entrypoint)
        return
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        log("skip: unreadable stdin payload")
        return

    started = time.time()
    response = await_final_response(payload.get("transcript_path", ""))
    waited = "waited %.1fs" % (time.time() - started)
    if response is None:
        log("skip: response text never reached the transcript")
        return
    labels = renderables(response.text)
    if not labels:
        log("skip: nothing to render (last message %d chars, %s)" % (len(response.text), waited))
        return
    summary = "%d chars, %s" % (len(response.text), ", ".join(labels))

    os.makedirs(OUT_DIR, exist_ok=True)
    path = document_path(payload.get("session_id") or "")
    name = os.path.basename(path)
    is_new = not os.path.exists(path)
    if not prepend_section(path, response, section_for(response)):
        log("skip: turn already in %s (%s)" % (name, waited))
        return
    prune_documents(keep=path)
    if not is_new:
        log("prepended response to %s (%s, %s)" % (name, summary, waited))
        return

    code = shutil.which("code") or "/opt/homebrew/bin/code"
    if not os.path.exists(code):
        log("wrote %s but `code` CLI not found" % name)
        return
    try:
        subprocess.run([code, "--reuse-window", path], timeout=15,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except (OSError, subprocess.SubprocessError) as err:
        log("wrote %s but `code` failed: %s" % (name, err))
        return
    log("wrote response and opened %s (%s, %s)" % (name, summary, waited))


if __name__ == "__main__":
    try:
        main()
    except Exception:
        pass
