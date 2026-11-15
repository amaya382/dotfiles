#!/usr/bin/env python3
"""Merge tracked Codex defaults with a machine-local TOML overlay."""

from copy import deepcopy
from datetime import date, datetime, time
import json
from pathlib import Path
import sys
import tempfile
import tomllib


def load(path):
    return tomllib.loads(path.read_text()) if path.exists() else {}


def merge(base, overlay):
    result = deepcopy(base)
    for key, value in overlay.items():
        result[key] = (merge(result[key], value)
                       if isinstance(result.get(key), dict) and isinstance(value, dict)
                       else deepcopy(value))
    return result


def capture(overlay, previous, current):
    result = deepcopy(overlay)
    for key in previous.keys() - current.keys():
        result.pop(key, None)
    for key, value in current.items():
        if key in previous and value == previous[key]:
            continue
        if isinstance(value, dict) and isinstance(previous.get(key), dict):
            result[key] = capture(result.get(key, {}) if isinstance(result.get(key), dict)
                                  else {}, previous[key], value)
        else:
            result[key] = deepcopy(value)
    return result


def value_toml(value):
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, bool):
        return str(value).lower()
    if isinstance(value, (datetime, date, time)):
        return value.isoformat()
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, list):
        return "[" + ", ".join(value_toml(item) for item in value) + "]"
    if isinstance(value, dict):
        return "{ " + ", ".join(json.dumps(key) + " = " + value_toml(item)
                                 for key, item in value.items()) + " }"
    raise ValueError(f"Unsupported TOML value type: {type(value).__name__}")


def dump(data):
    lines = []

    def table(items, path):
        if path:
            lines.extend(["", "[" + ".".join(json.dumps(key) for key in path) + "]"])
        for key, value in items.items():
            if not isinstance(value, dict):
                lines.append(json.dumps(key) + " = " + value_toml(value))
        for key, value in items.items():
            if isinstance(value, dict):
                table(value, path + [key])

    table(data, [])
    return "\n".join(lines).lstrip() + "\n"


def atomic_write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as output:
        temporary = Path(output.name)
        try:
            output.write(text)
            output.close()
            temporary.replace(path)
        finally:
            temporary.unlink(missing_ok=True)


def plan(base_path, config_dir):
    base = load(base_path)
    for name in ("config.toml", "config.local.toml", ".config.rendered.toml"):
        if (config_dir / name).is_symlink():
            raise ValueError(f"Refusing symlinked Codex runtime file: {name}")
    live = load(config_dir / "config.toml")
    overlay = load(config_dir / "config.local.toml")
    snapshot = config_dir / ".config.rendered.toml"
    if (config_dir / "config.toml").exists():
        if snapshot.exists():
            overlay = capture(overlay, load(snapshot), live)
        else:
            overlay = merge(capture({}, base, live), overlay)
    rendered = dump(merge(base, overlay))
    tomllib.loads(rendered)
    return rendered, overlay


def run(base_path, config_dir, action="render"):
    rendered, overlay = plan(base_path, config_dir)
    if action == "capture":
        atomic_write(config_dir / "config.local.toml", dump(overlay))
        return ""
    if action == "record":
        if load(config_dir / "config.toml") == tomllib.loads(rendered):
            atomic_write(config_dir / ".config.rendered.toml", rendered)
        return ""
    return rendered


if __name__ == "__main__":
    base_path = Path(__file__).resolve().parent.parent / "home/.codex/config.base.toml"
    config_dir = Path.home() / ".codex"
    action = sys.argv[1].removeprefix("--") if len(sys.argv) == 2 else "render"
    try:
        if action not in {"render", "capture", "record"}:
            raise ValueError("Expected --capture, --record, or no argument")
        if config_dir.resolve().is_relative_to(base_path.parent.parent.parent):
            raise ValueError("Codex runtime settings must stay outside the dotfiles repository")
        sys.stdout.write(run(base_path, config_dir, action))
    except (OSError, ValueError) as error:
        sys.exit(str(error))
