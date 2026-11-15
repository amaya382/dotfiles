#!/usr/bin/env python3
"""Render tracked Claude rules as global Codex instructions on stdout."""

from pathlib import Path
import sys


def render(rules_dir: Path) -> str:
    sections = ["""# Working rules

各節の適用条件に従うこと。条件中の paths は、そのパターンに一致するファイルを扱うときに適用する。
AskUserQuestion は利用可能な質問手段、Explore subagent / Agent tool は利用可能な委譲手段として解釈する。対応するツールがない場合、質問は通常の会話で行い、委譲できない作業は自分で行う。
参照されたスキルが利用可能なスキル一覧にない場合は、存在する ~/.claude/skills/<skill-name>/SKILL.md を読んで手順を確認する。ツール固有の機能は、利用可能な同等の手段がある場合に置き換える。
"""]
    claude = rules_dir.parent / "CLAUDE.md"
    sections.append("## CLAUDE.md\n\n" + claude.read_text(encoding="utf-8").strip() + "\n")
    paths = sorted(rules_dir.rglob("*.md"))
    if not paths:
        raise ValueError(f"No Markdown rules found in {rules_dir}")
    for path in paths:
        lines = path.read_text(encoding="utf-8").splitlines()
        metadata = []
        if lines and lines[0] == "---":
            try:
                end = lines.index("---", 1)
            except ValueError:
                raise ValueError(f"Unclosed frontmatter: {path}") from None
            metadata, lines = lines[1:end], lines[end + 1:]
        section = f"## {path.relative_to(rules_dir).as_posix()}\n"
        if metadata:
            section += "\n適用条件・メタデータ:\n\n```yaml\n" + "\n".join(metadata) + "\n```\n"
        section += "\n" + "\n".join(lines).strip() + "\n"
        sections.append(section)
    voice = rules_dir.parent.parent / ".codex/voice-instructions.md"
    sections.append(voice.read_text(encoding="utf-8").strip() + "\n")
    return "\n".join(sections)


if __name__ == "__main__":
    rules_dir = (Path(sys.argv[1]) if len(sys.argv) > 1 else
                 Path(__file__).resolve().parent.parent / "home/.claude/rules")
    try:
        sys.stdout.write(render(rules_dir))
    except (OSError, ValueError) as error:
        sys.exit(str(error))
