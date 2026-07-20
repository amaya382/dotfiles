# dotfiles (chezmoi)

[chezmoi](https://www.chezmoi.io/) 管理下の dotfiles。

## Setup

新しいマシンで:

```bash
# 1. chezmoi をインストール
brew install chezmoi
# または
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. このリポジトリから初期化 & 適用
chezmoi init --apply amaya382/dotfiles
```

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

`chezmoi apply` 時に `run_once_install-packages.sh` が実行され、以下がセットアップされる:

- 基本パッケージ (tmux, zsh, vim, fzf など)
- Homebrew (Linux/macOS)
- anyrc, zplug, tpm, dein.vim
- デフォルトシェルの zsh 化

## 日常操作

```bash
chezmoi status     # 差分の一覧
chezmoi diff       # 差分の詳細
chezmoi edit ~/.zshrc  # ソースを直接編集
chezmoi apply      # ~/ に反映
chezmoi cd         # ソースディレクトリに移動
```
