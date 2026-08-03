---
description: Applies when investigating a codebase — reading a repository to understand its spec or implementation, before making a change. / コードベースを調査するときに適用する。変更を加える前に、仕様や実装を理解するためにリポジトリを読む作業が対象。
---

# rules for investigation

- 調査でリポジトリを読むときは default branch (main branch) を最優先で参照すること
  - 作業中リポジトリと参照用リポジトリの区別なく適用する
  - checkout 中のブランチや worktree の内容は未完成の変更を含むため、既定の参照先にしない
- 調査対象に関連する未マージの変更がある場合は、default branch の内容を把握したうえで差分として追加確認すること
  - 報告では default branch の内容と未マージ差分を区別して書くこと
