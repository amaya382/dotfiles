#!/usr/bin/env python3
"""Render a portable Codex skill from the repository's Claude skill source."""

from pathlib import Path
import json
import re
import shutil
import subprocess
import sys


def render(name: str, source_root: Path) -> str:
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
        raise ValueError(f"Invalid skill directory name: {name}")
    source = source_root / name / "SKILL.md"
    lines = source.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        raise ValueError(f"Missing frontmatter: {source}")
    try:
        end = lines.index("---", 1)
    except ValueError:
        raise ValueError(f"Unclosed frontmatter: {source}") from None
    portable = {"name", "description", "license", "compatibility", "metadata", "allowed-tools"}
    metadata = []
    keep = False
    for line in lines[1:end]:
        field = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*):", line)
        if field:
            if field.group(1) not in portable | {"model"}:
                raise ValueError(f"Unsupported Claude skill field in {name}: {field.group(1)}")
            keep = field.group(1) in portable
        if keep:
            metadata.append(line)
    for index, line in enumerate(metadata):
        if line.startswith("description: "):
            value = line.removeprefix("description: ")
            if value and value[0] not in "|>\"'":
                metadata[index] = "description: " + json.dumps(value, ensure_ascii=False)
    yq = shutil.which("yq") or next((str(path) for path in (
        Path("/home/linuxbrew/.linuxbrew/bin/yq"), Path("/opt/homebrew/bin/yq"),
        Path("/usr/local/bin/yq")) if path.is_file()), None)
    if yq is None:
        raise ValueError("yq is required to validate skill frontmatter; run mise bootstrap first")
    parsed = subprocess.run([yq, "--output-format=json", "."],
                            input="\n".join(metadata), text=True, capture_output=True)
    if parsed.returncode:
        raise ValueError(f"Invalid YAML frontmatter in skill: {name}")
    fields = json.loads(parsed.stdout)
    if (not isinstance(fields, dict) or fields.get("name") != name
            or not isinstance(fields.get("description"), str)
            or not fields["description"].strip()):
        raise ValueError(f"Skill {name} requires a matching name and a nonempty description")
    body = "\n".join(lines[end + 1:])
    body = body.replace("~/.claude/skills/", "~/.agents/skills/")
    body = body.replace("ExitPlanMode を呼び直さず AskUserQuestion で", "利用可能な質問手段で")
    body = body.replace("ExitPlanMode で提示", "通常の会話で提示")
    body = body.replace("Use a HEREDOC for `--body` to preserve formatting.",
                        "Write the body to a temporary file and use `--body-file` to preserve formatting.")
    return "---\n" + "\n".join(metadata) + "\n---\n" + body + "\n"


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: render-codex-skill.py <skill-name>")
    source_root = Path(__file__).resolve().parent.parent / "home/.claude/skills"
    try:
        sys.stdout.write(render(sys.argv[1], source_root))
    except (OSError, ValueError) as error:
        sys.exit(str(error))
