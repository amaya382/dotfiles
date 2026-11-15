#!/usr/bin/env python3
"""Sync repository-managed Claude skills into Codex's user skill directory."""

import hashlib
import json
from pathlib import Path
import runpy
import sys
import tempfile


def atomic_write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as output:
        temporary = Path(output.name)
        try:
            output.write(data)
            output.close()
            temporary.replace(path)
        finally:
            temporary.unlink(missing_ok=True)


def matches(path, entry):
    if entry["kind"] == "link":
        return path.is_symlink() and path.resolve() == Path(entry["target"]).resolve()
    return (path.is_file() and not path.is_symlink()
            and hashlib.sha256(path.read_bytes()).hexdigest() == entry["sha256"])


def sync(source, target, state_path, exclusions, render):
    previous = json.loads(state_path.read_text()) if state_path.exists() else {}
    desired, content = {}, {}
    for skill in sorted(source.iterdir()):
        if skill.name.startswith(".") or skill.name in exclusions or not (skill / "SKILL.md").is_file():
            continue
        if skill.is_symlink():
            raise ValueError(f"Refusing symlinked skill source: {skill}")
        rendered = render(skill.name, source).encode("utf-8")
        for item in sorted(skill.rglob("*")):
            relative = item.relative_to(source)
            if any(part in {".git", "__pycache__", ".DS_Store"} for part in relative.parts):
                continue
            if item.is_symlink():
                raise ValueError(f"Refusing symlinked skill resource: {item}")
            if not item.is_file():
                continue
            key = relative.as_posix()
            if item == skill / "SKILL.md":
                desired[key] = {"kind": "render", "sha256": hashlib.sha256(rendered).hexdigest()}
                content[key] = rendered
            else:
                desired[key] = {"kind": "link", "target": str(item.resolve())}

    for key in set(previous) | set(desired):
        relative = Path(key)
        if relative.is_absolute() or ".." in relative.parts:
            raise ValueError(f"Invalid managed path: {key}")
        path = target / relative
        for parent in [target.parent, target, *path.parents]:
            if parent == target.parent.parent:
                break
            if parent.is_symlink() or (parent.exists() and not parent.is_dir()):
                raise ValueError(f"Refusing non-directory skill parent: {parent}")
        if not path.exists() and not path.is_symlink():
            continue
        if key in desired and matches(path, desired[key]):
            continue
        if key not in previous or not matches(path, previous[key]):
            raise ValueError(f"Local skill file conflicts with sync: {path}")

    for key, entry in desired.items():
        path = target / key
        if matches(path, entry):
            continue
        path.parent.mkdir(parents=True, exist_ok=True)
        if entry["kind"] == "render":
            atomic_write(path, content[key])
        else:
            with tempfile.TemporaryDirectory(dir=path.parent) as directory:
                temporary = Path(directory) / "link"
                temporary.symlink_to(entry["target"])
                temporary.replace(path)

    for key in previous.keys() - desired.keys():
        path = target / key
        if path.exists() or path.is_symlink():
            path.unlink()
    atomic_write(state_path, (json.dumps(desired, indent=2) + "\n").encode())
    return sum(key.endswith("/SKILL.md") for key in desired)


if __name__ == "__main__":
    repo = Path(__file__).resolve().parent.parent
    source = repo / "home/.claude/skills"
    target = Path.home() / ".agents/skills"
    state = Path.home() / ".codex/.skills-sync.json"
    try:
        if target.resolve().is_relative_to(repo) or state.parent.resolve().is_relative_to(repo):
            raise ValueError("Generated skills and sync state must stay outside the repository")
        exclusions = {line.split("#", 1)[0].strip() for line in
                      (repo / "home/.codex/skills.exclude").read_text().splitlines()}
        render = runpy.run_path(str(repo / "bootstrap/render-codex-skill.py"))["render"]
        count = sync(source, target, state, exclusions, render)
        print(f"Synced {count} Claude skills to {target}")
    except (OSError, ValueError, KeyError) as error:
        sys.exit(str(error))
