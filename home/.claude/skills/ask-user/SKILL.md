---
name: ask-user
description: ユーザーに判断・確認・レビューを求めるときに必ず使う。crit のインラインコメントと AskUserQuestion のどちらで聞くかを決め、その手順で聞く。Use whenever you need a decision, confirmation, clarification, or review from the user — before calling AskUserQuestion or asking a question in chat.
---

# ask-user

## 手段の選び方

判断の対象がファイル上の特定の箇所にあるなら crit、なければ AskUserQuestion を使う。

crit を使う場面:

- 書いたドキュメント・コード・計画の特定の箇所について判断してほしいとき
- 文章そのものの評価がほしいとき
- 選択肢が多い、各案の説明が長い、複数の論点が絡むなど、AskUserQuestion の選択肢に収まらないとき。選択肢と評価を書いたファイルを用意して crit で示す

AskUserQuestion を使う場面:

- 判断の対象を載せるファイルがまだないとき（作業開始前の確認、目的の確認、worktree を切るかどうか）
- 操作の承認だけを求めるとき（commit、push、外部への送信、削除）
- 短い選択で答えられ、各案の説明が 1 行に収まるとき
- `command -v crit` が失敗するとき

1 回の確認に両方が含まれる場合は分ける。ファイル上の論点は crit で聞き、承認は AskUserQuestion で聞く。

## 質問の書き方

- 推奨とその理由を先に書き、続けて判断を左右する軸と案ごとの評価を書く
- 1 つのコメントまたは質問には 1 つの論点だけを書く
- 前後の会話を見なくても答えられるように、何を決めると何が変わるかを書く
- 質問を TODO や注記として成果物の本文に書き込まない。質問は crit のコメントに置く

## crit での手順

この skill に従う場合、ユーザーの明示的な指示を待たずに crit のレビューを開始してよい。コマンドの詳細は `crit:crit` と `crit:crit-cli` skill に従う。

1. 対象ファイルを書き終えてから `crit <file>...` を `run_in_background: true`、`timeout: 86400000` で起動し、表示された URL をユーザーに伝える
2. `crit comment --author 'Claude Code'` で質問を置く。特定の箇所に関する質問は行コメント、ファイル全体や複数ファイルにまたがる質問はファイルコメントかレビューコメントにする。3 件以上は `--json --file` でまとめて置く
3. ユーザーが Finish Review を押して `crit` が終了するまで待つ。終了したら stdout を読む
4. 返信に応じて成果物を直し、各コメントに `--reply-to` で対応内容を返す。`--resolve` は付けない
5. `crit` を再度起動して次の round を待つ。コメントがないまま Finish Review が押されたら合意とみなして先へ進む
