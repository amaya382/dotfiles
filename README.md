# dotfiles

Uses [mise](https://mise.jdx.dev/) as a dotfile manager, system-package manager, and language-runtime manager, driven by `mise bootstrap` and `mise dotfiles` (both stabilized in mise 2026.7.4).

## Repository layout

```
dotfiles/
├── mise/
│   ├── config.toml         # main config, deployed as ~/.config/mise/config.toml
│   └── config.macos.toml   # macOS-only extras (auto-merged by mise on macOS)
├── home/                # dotfile bodies placed under ~/
│   ├── .miserc.toml     # early-init config that enables auto_env for the macOS overlay
│   ├── .zshrc.tera      # tera template (OS-conditional)
│   ├── .tmux.conf.tera
│   ├── .vimrc
│   ├── .anyrc
│   ├── .gitconfig
│   ├── .gitignore_global
│   ├── Brewfile         # macOS-only Homebrew casks (linked to ~/Brewfile on macOS)
│   ├── .claude/         # Claude Code config and shared instruction/skill sources
│   │   ├── CLAUDE.md
│   │   ├── rules/
│   │   ├── skills/             # automatically discovered for Codex
│   │   ├── settings.base.json  # shared Claude settings
│   │   └── settings.json.tera
│   └── .codex/
│       ├── AGENTS.md.tera
│       ├── voice-instructions.md  # included in generated AGENTS.md
│       ├── config.base.toml       # shared Codex settings
│       ├── config.toml.tera
│       └── skills.exclude         # Claude-only skill directory names
└── bootstrap/           # scripts invoked from bootstrap.hooks, templates and tasks
    ├── install-3rdparty.sh
    ├── render-claude-settings.sh
    ├── render-codex-agents.py
    ├── render-codex-config.py
    ├── render-codex-skill.py
    └── sync-codex-skills.py
```

## Setup

On a new machine:

```bash
# 1. Install mise itself (needed to drive bootstrap).
curl https://mise.run | sh
export PATH=$HOME/.local/bin:$PATH

# 2. Clone this repo. The path is flexible; the config discovers it via the
#    ~/.config/mise symlink below.
git clone git@github.com:amaya382/dotfiles.git <clone-path>

# 3. Symlink the entire mise config directory. Every mise config file
#    (config.toml, config.macos.toml, ...) becomes visible in one step, and
#    the repo's location stops being hardcoded in the config.
mkdir -p ~/.config
ln -sn <clone-path>/mise ~/.config/mise
mise trust ~/.config/mise/config.toml

# 4. Bootstrap: system packages → dotfile placement → language runtimes, in one command.
mise bootstrap --yes
```

`mise bootstrap` is idempotent, so re-run it any time to reconverge.

## What bootstrap does

`mise bootstrap` runs these phases declaratively, in order:

1. **`bootstrap.packages`** — reconciles apt (build-essential, ...) and brew (tmux, vim, gh, uv, custom taps, ...). Brew formulae are installed by mise's built-in bottle installer, so Homebrew itself is not required. On macOS, `config.macos.toml` adds the GNU coreutils variants (`gawk` / `grep` / `gnu-sed`).
2. **`post-packages` hook** — runs `bootstrap/install-3rdparty.sh` to install anyrc and dein.vim. On macOS it also runs `brew bundle` against `~/Brewfile` (symlinked from `home/Brewfile`) to install GUI casks such as Docker Desktop, DBeaver, and AltTab. Installing and upgrading are separated: `brew bundle --no-upgrade` only adds what is missing, and each already-installed cask that is outdated is offered one at a time as `upgrade <cask>? [y/N]` (default: skip). Without a controlling terminal — `mise bootstrap` from a script or CI — there is nobody to ask, so every outdated cask is upgraded as before. Requires Homebrew; missing brew emits a warning and skips. zplug is installed as a Homebrew formula in the previous phase.
3. **`pre-dotfiles` hook** — creates parent directories and captures changes to the live Codex config into its local overlay.
4. **`dotfiles`** — applies `[dotfiles]` entries, symlinking or templating from `home/` into `~/`. `.claude/{rules,skills,hooks}` use `symlink-each`, so machine-local files dropped into those dirs stay outside mise's management. `~/.claude/settings.json`, `~/.codex/config.toml` and `~/.codex/AGENTS.md` are rendered. The `post-dotfiles` hook records the applied Codex config and synchronizes shared skills.
5. **`bootstrap.user`** — sets `login_shell` (`/usr/bin/zsh` on Linux, `/bin/zsh` on macOS via `config.macos.toml`).
6. **`tools`** — installs the node / python / go / java versions declared in `[tools]`, plus `github:` releases (`baretree`, `ftgrep`) fetched via ubi since those personal taps have no Homebrew API metadata.

Individual phases can be targeted with `mise bootstrap --skip <phase>` or `--only <phase>`.

## Per-machine Claude Code settings

Claude Code reads exactly one user-scope settings file, and its `settings.local.json` layer belongs to a repository root rather than to `~`. Machine-specific values therefore cannot live in a second file that Claude Code would pick up on its own. `~/.claude/settings.json` is rendered instead of symlinked:

```
home/.claude/settings.base.json  (tracked)  ─┐
                                             ├─→  ~/.claude/settings.json  (rendered)
~/.claude/settings.local.json    (untracked) ┘
```

`bootstrap/render-claude-settings.sh` performs the merge; objects merge recursively and arrays merge as an order-preserving union, with the overlay winning on scalars. Put anything machine-specific — a different Vertex project, a sandbox path that only exists on this box — into `~/.claude/settings.local.json`.

Claude Code also writes to the rendered file on its own (`/permissions` at user scope, `/plugin` enable). Each render diffs the live file against the previous render, recorded in `~/.claude/.settings.rendered.json`, and folds whatever changed into the overlay. Those writes survive the next apply and stay out of git, while edits to the base still reach every machine. The overlay cannot express a deletion, though: to drop a setting, edit the base or the overlay itself.

Two constraints come with this:

- **Apply from a plain terminal.** Claude Code sandboxes its own settings files against writes from processes it spawns, so `mise dotfiles apply` fails on this entry when run from inside a session. The render aborts before touching the snapshot, so nothing is lost — just re-run it outside.
- **Do not start Claude Code from `$HOME`.** `$HOME` is not a git repository, so a session started there treats its working directory as the project root and claims `~/.claude/settings.local.json` as its repository-local settings — reading the overlay a second time at higher precedence, and writing to it whenever a permission is granted at local scope. Such a grant would then be absorbed into the overlay and merged into the global settings for good.

## Codex instructions and skills

`bootstrap/render-codex-agents.py` combines `home/.claude/CLAUDE.md`, `home/.claude/rules/*.md` and `home/.codex/voice-instructions.md` into `~/.codex/AGENTS.md`. It preserves rule applicability metadata.

`bootstrap/sync-codex-skills.py` discovers every `home/.claude/skills/<name>/SKILL.md`, generates its Codex manifest in `~/.agents/skills/<name>/SKILL.md`, and links supporting files from the repository. Skill-specific templates and mise entries are unnecessary. `home/.codex/skills.exclude` lists excluded directory names, one per line; it currently excludes the Claude-only `session-status` skill.

The converter removes Claude's `model` field, rewrites skill reference paths and known question/approval tool names, and rejects unsupported frontmatter fields. A skill that depends on other Claude-specific behavior still needs adaptation or exclusion. Synchronization stops on conflicting local files or locally modified outputs. It removes obsolete outputs only when they still match the recorded generated version, preserving unrelated local files.

## Per-machine Codex settings

`home/.codex/config.base.toml` stores shared model, reasoning effort and voice preferences. `bootstrap/render-codex-config.py` recursively merges these defaults with `~/.codex/config.local.toml`; local values win and arrays are replaced. On first apply, it preserves existing live settings that differ from the shared defaults in the local overlay.

The pre-dotfiles hook captures later live edits relative to `~/.codex/.config.rendered.toml`. The post-dotfiles hook records the result after applying it. Template rendering is read-only, so previews do not update the overlay or snapshot. Project trust settings, device-specific state and other machine-only values stay outside the repository, alongside the generated `~/.codex/config.toml`. Removing a local-only key from the live config removes its override on apply; removing a shared key restores its default. Edit the base to remove a shared default.

Skill ownership is recorded locally in `~/.codex/.skills-sync.json`. The synchronizer reads repository sources rather than `~/.claude/skills`, so machine-local Claude skills are not exported.

## Updating Codex

Edit the shared sources in this repository, then apply the relevant change:

| Change | Source | Command |
|---|---|---|
| Instructions or voice preferences | `home/.claude/CLAUDE.md`, `home/.claude/rules/`, `home/.codex/voice-instructions.md` | `mise dotfiles apply ~/.codex/AGENTS.md` |
| Shared Codex settings | `home/.codex/config.base.toml` | `mise dotfiles apply ~/.codex/config.toml` |
| Add or update a shared skill | `home/.claude/skills/<name>/SKILL.md` and supporting files | `mise run codex:sync-skills` |
| Exclude a Claude-only skill | Add its directory name to `home/.codex/skills.exclude` | `mise run codex:sync-skills` |

`mise dotfiles apply` and `mise bootstrap` also synchronize skills through the post-dotfiles hook, including when apply is restricted to another target. The dedicated task updates skills without applying other dotfiles. Check the reported skill count and generated manifests under `~/.agents/skills/`. If synchronization reports a local conflict, move the conflicting file aside or add the source skill to the exclusion list before retrying.

## Day-to-day commands

```bash
mise bootstrap status               # convergence dashboard for every phase
mise bootstrap --dry-run            # preview what would change
mise dotfiles status                # dotfile-only status
mise dotfiles apply                 # re-apply dotfiles
mise dotfiles edit ~/.zshrc         # edit the managed source
mise dotfiles add ~/.foo            # start tracking a new file
```

`mise dotfiles edit ~/.claude/settings.json` opens the template, not the settings. Edit `home/.claude/settings.base.json` and re-apply instead.

## Adding tools

- **Homebrew formulae**: add `"brew:foo" = "latest"` under `[bootstrap.packages]` in `mise/config.toml` (or `config.macos.toml` for macOS-only formulae), then run `mise bootstrap`.
- **Homebrew casks (macOS GUI apps)**: add a `cask "foo"` line to `home/Brewfile`, then run `mise bootstrap`. Upgrades of already-installed casks are asked per cask (see phase 2 above); answering `n` leaves the app where it is until the next run. Do not duplicate formulae here — keep those under mise's `brew:` backend — and do not use `brew bundle cleanup`, which would remove mise-managed formulae.
- **GitHub-release binaries**: add `"github:owner/repo" = "latest"` under `[tools]` for tools that Homebrew doesn't carry.
- **Language runtimes**: add an entry under `[tools]`, then run `mise install`.
- **New dotfile**: drop the file under `home/`, add a `[dotfiles]` entry, and run `mise dotfiles apply`. Alternatively `mise dotfiles add ~/.foo` captures a live file automatically.
