# dotfiles

Uses [mise](https://mise.jdx.dev/) as a dotfile manager, system-package manager, and language-runtime manager. This replaces the previous three-layer setup (chezmoi + Brewfile + `.tool-versions`) with `mise bootstrap` and `mise dotfiles`, both stabilized in mise 2026.7.4.

## Repository layout

```
dotfiles/
├── mise/
│   ├── config.toml         # main config, deployed as ~/.config/mise/config.toml
│   └── config.macos.toml   # macOS-only extras (auto-merged by mise on macOS)
├── home/                # dotfile bodies placed under ~/
│   ├── .zshrc.tera      # tera template (OS-conditional)
│   ├── .tmux.conf.tera
│   ├── .vimrc
│   ├── .gitconfig
│   ├── .anyrc / .anyrc.d/
│   └── .claude/         # Claude Code rules / skills (rules/references/skills use symlink-each)
└── bootstrap/           # scripts invoked from bootstrap.hooks
    └── install-3rdparty.sh   # anyrc / dein.vim (post-packages; zplug ships via Homebrew)
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

1. **`bootstrap.packages`** — reconciles apt (build-essential, ...) and brew (tmux, vim, gh, uv, custom taps, ...). Brew formulae are installed by mise's built-in bottle installer, so Homebrew itself is not required.
2. **`post-packages` hook** — runs `bootstrap/install-3rdparty.sh` to install anyrc and dein.vim. zplug is now installed as a Homebrew formula in the previous phase.
3. **`dotfiles`** — applies `[dotfiles]` entries, symlinking or templating from `home/` into `~/`.
4. **`bootstrap.user`** — sets `login_shell = "/usr/bin/zsh"`.
5. **`tools`** — installs the node / python / go versions declared in `[tools]`.

Individual phases can be targeted with `mise bootstrap --skip <phase>` or `--only <phase>`.

## Day-to-day commands

```bash
mise bootstrap status               # convergence dashboard for every phase
mise bootstrap --dry-run            # preview what would change
mise dotfiles status                # dotfile-only status
mise dotfiles apply                 # re-apply dotfiles
mise dotfiles edit ~/.zshrc         # edit the managed source
mise dotfiles add ~/.foo            # start tracking a new file
```

## Adding tools

- **Homebrew formulae**: add `"brew:foo" = "latest"` under `[bootstrap.packages]` in `mise/config.toml`, then run `mise bootstrap`.
- **Language runtimes**: add an entry under `[tools]`, then run `mise install`.
- **New dotfile**: drop the file under `home/`, add a `[dotfiles]` entry, and run `mise dotfiles apply`. Alternatively `mise dotfiles add ~/.foo` captures a live file automatically.
