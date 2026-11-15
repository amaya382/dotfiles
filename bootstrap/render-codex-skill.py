#!/usr/bin/env python3
"""Render a portable Codex skill from the repository's Claude skill source."""

from pathlib import Path
import json
import sys


def render(name: str, source_root: Path) -> str:
    if name not in {"create-pr", "technical-writing"}:
        raise ValueError(f"Unsupported shared skill: {name}")
    source = source_root / name / "SKILL.md"
    lines = source.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        raise ValueError(f"Missing frontmatter: {source}")
    try:
        end = lines.index("---", 1)
    except ValueError:
        raise ValueError(f"Unclosed frontmatter: {source}") from None
    metadata = [line for line in lines[1:end] if not line.startswith("model:")]
    for index, line in enumerate(metadata):
        if line.startswith("description: "):
            value = line.removeprefix("description: ")
            if value and value[0] not in "|>\"'":
                metadata[index] = "description: " + json.dumps(value, ensure_ascii=False)
    body = "\n".join(lines[end + 1:])
    body = body.replace("~/.claude/skills/technical-writing/references/",
                        "~/.agents/skills/technical-writing/references/")
    body = body.replace("ExitPlanMode を呼び直さず AskUserQuestion で", "利用可能な質問手段で")
    body = body.replace("ExitPlanMode で提示", "通常の会話で提示")
    body = body.replace("Use a HEREDOC for `--body` to preserve formatting.",
                        "Write the body to a temporary file and use `--body-file` to preserve formatting.")
    return "---\n" + "\n".join(metadata) + "\n---\n" + body + "\n"


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: render-codex-skill.py <create-pr|technical-writing>")
    source_root = Path(__file__).resolve().parent.parent / "home/.claude/skills"
    try:
        sys.stdout.write(render(sys.argv[1], source_root))
    except (OSError, ValueError) as error:
        sys.exit(str(error))
