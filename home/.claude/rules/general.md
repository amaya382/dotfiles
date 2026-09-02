---
description: Applies to every task — ambiguous requests, delegation to subagents, explanatory writing, and pacing after the user interrupts. / すべての作業に適用する。曖昧な依頼、subagent への委譲、説明の書き方、ユーザーの割り込み後の進め方が対象。
---

# general rules

- 曖昧性や不確実性がある場合は想像で進めずに必ず AskUserQuestion で確認すること
  - 曖昧さ、承認が要る操作、目的の不明があるときの質問は正当な手段である
- Use of Agents
  - 独立した調査は Explore subagent に委譲すること
  - 独立した並列作業は Agent tool でファンアウトすること
  - 委譲判断で迷ったら委譲する側に倒すこと

## 対話と進め方

- アーティファクト (ドキュメント、コードコメントなど) に会話の指示・制約・避けた選択肢・修正履歴などの過程やその痕跡（「〜という指示に基づき」「〜は使わない」等）を絶対に残さないこと
- 複数の案を出す時は、推奨とその理由を先に書き、続けて判断を左右する軸と案ごとの評価を示すこと
- 会話中の例はそのまま成果物に転用せず、意図を読み取るための参考材料としてのみ使うこと
- この環境で表示されるのはターン末尾の本文だけである。伝える内容はすべてターン末尾に置くこと
