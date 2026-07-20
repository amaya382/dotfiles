# dotfiles (chezmoi)

[chezmoi](https://www.chezmoi.io/) 管理下の dotfiles。

## Setup

新しいマシンで:

```bash
# 1. chezmoi を事前に手動インストール (Brewfile では管理していない)
brew install chezmoi
# または
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. このリポジトリから初期化 & 適用
chezmoi init --apply amaya382/dotfiles
```

**注記**: chezmoi 自身は Brewfile に含めていない。理由は「Brewfile を配置し `brew bundle` を走らせるのは chezmoi 自身」で、自己解決の順序が回らないため。

## 管理対象

| Path | 種類 |
|---|---|
| `~/.zshrc` | テンプレート (OS 分岐) |
| `~/.tmux.conf` | テンプレート (OS 分岐) |
| `~/.vimrc` | ファイル |
| `~/.gitconfig` | ファイル |
| `~/.gitignore_global` | ファイル |
| `~/.anyrc`, `~/.anyrc.d/` | ファイル + symlink 群 |
| `~/.tmux/plugins/` | ディレクトリ (tpm が中身を管理) |
| `~/.vim/dein/` | ディレクトリ (dein が中身を管理) |
| `~/.claude/CLAUDE.md` | ファイル |
| `~/.claude/settings.json` | ファイル |
| `~/.claude/rules/`, `references/`, `skills/` | ファイル + symlink 群 |

## パッケージインストール

### 事前手動 (Setup 節)

- **chezmoi** 本体

### 自動 (chezmoi apply 時)

**`run_once_install-packages.sh` (初回のみ):**
- OS 標準パッケージ (tmux, zsh, vim, fzf など)
- Homebrew 本体 (Linux/macOS)
- anyrc, zplug, tpm, dein.vim
- デフォルトシェルの zsh 化

**`run_onchange_after_brew-bundle.sh` (Brewfile 変更時):**
- `~/.Brewfile` に基づく `brew bundle --global`
- gh, jq, mise, mkcert, ripgrep, uv, baretree, ftgrep など

### ツールを追加したいとき

```bash
chezmoi edit ~/.Brewfile   # brew "foo" を追記
chezmoi apply              # 自動で brew bundle が走る
```

## 日常操作

```bash
chezmoi status     # 差分の一覧
chezmoi diff       # 差分の詳細
chezmoi edit ~/.zshrc  # ソースを直接編集
chezmoi apply      # ~/ に反映
chezmoi cd         # ソースディレクトリに移動
```
