# Neovim スクリーンショットギャラリー

**言語：** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

Windows 用 Neovim・WezTerm 設定のスクリーンショットです。隔離したプレビュー環境とサンプルファイルを使用しています。AI の画面は配置または初期設定のみ、デバッグ画面は実行中のセッションがないパネルのみを示します。クラウドへのデプロイやアカウント操作は含みません。

[メイン README に戻る](../../README.ja.md)

- [編集とナビゲーション](#編集とナビゲーション)
- [執筆とデータ](#執筆とデータ)
- [Git と履歴](#git-と履歴)
- [ターミナルとツール](#ターミナルとツール)
- [AI ワークスペース](#ai-ワークスペース)
- [日本語執筆プロファイル](#日本語執筆プロファイル)

## 編集とナビゲーション

| プレビュー | 機能 |
| --- | --- |
| [![起動時のダッシュボード](dashboard.png)](dashboard.png) | **起動時のダッシュボード** — サメのロゴと、ファイル・検索・プラグイン・ターミナル用のショートカット。 |
| [![エディターとファイルエクスプローラー](editor-explorer.png)](editor-explorer.png) | **エディターとファイルエクスプローラー** — プロジェクトツリーの横で Lua を編集。上部には開いているファイルを表示。 |
| [![ファイル選択](file-picker.png)](file-picker.png) | **ファイル選択** — ファイル名で検索し、選択したファイルをプレビュー。 |
| [![ショートカットの確認](shortcuts.png)](shortcuts.png) | **ショートカットの確認** — Which-Key がリーダーキーのショートカットを用途別に表示。 |
| [![プロジェクト内のテキスト検索](search.png)](search.png) | **プロジェクト内のテキスト検索** — プロジェクト内の検索結果と、選択した行のプレビュー。 |
| [![TODO の検索](todo.png)](todo.png) | **TODO の検索** — TODO の検索結果と、その前後のコードを表示。 |
| [![一時メモ](scratch.png)](scratch.png) | **一時メモ** — コードの横で使えるフローティングメモ。 |
| [![通知履歴](notifications.png)](notifications.png) | **通知履歴** — 過去のエディターメッセージを通知履歴にまとめて表示。 |
| [![Zen モード](zen.png)](zen.png) | **Zen モード** — 周囲のパネルを隠し、Markdown 文書を中央に表示。 |

## 執筆とデータ

| プレビュー | 機能 |
| --- | --- |
| [![コード補完](completion.png)](completion.png) | **コード補完** — Lua の補完候補と、選択した項目のドキュメント。 |
| [![言語診断](diagnostics.png)](diagnostics.png) | **言語診断** — Python の型エラーをコード内と診断パネルに表示。 |
| [![Markdown の表示](markdown.png)](markdown.png) | **Markdown の表示** — 見出し、チェックボックス、コールアウト、コード、表を装飾。 |
| [![CSV テーブル](csv.png)](csv.png) | **CSV テーブル** — CSV の値を列にそろえて表示し、そのままテキストとして編集。 |
| [![Obsidian ノート](obsidian.png)](obsidian.png) | **Obsidian ノート** — サンプル Vault のノートをクイックスイッチで検索し、内容をプレビュー。 |
| [![画像プレビュー](image_preview.png)](image_preview.png) | **画像プレビュー** — 画像を専用の WezTerm プレビュータブに表示。 |

## Git と履歴

| プレビュー | 機能 |
| --- | --- |
| [![Git の状態](git.png)](git.png) | **Git の状態** — Neogit が変更ファイルと未ステージの変更を表示。 |
| [![差分の並列表示](diff.png)](diff.png) | **差分の並列表示** — 変更ファイルの一覧と、コードの差分を左右に並べて表示。 |
| [![取り消し履歴](undo.png)](undo.png) | **取り消し履歴** — 編集中のバッファの横に取り消し履歴の分岐を表示。 |

## ターミナルとツール

| プレビュー | 機能 |
| --- | --- |
| [![プロジェクトのターミナル](terminal.png)](terminal.png) | **プロジェクトのターミナル** — コードの下にプロジェクトターミナルを開き、フォルダーの内容を表示。 |
| [![フローティングターミナル](floating_terminal.png)](floating_terminal.png) | **フローティングターミナル** — コードを表示したまま、その上にターミナルを開く。 |
| [![クラウド設定言語の編集](cloud_languages.png)](cloud_languages.png) | **クラウド設定言語の編集** — Terraform と Azure Pipelines YAML を左右に並べて表示。 |
| [![壁紙マネージャー](wallpapers.png)](wallpapers.png) | **壁紙マネージャー** — 壁紙マネージャーで画像参照、お気に入り、ランダム選択、起動設定を選択。 |
| [![プラグインマネージャー](plugins.png)](plugins.png) | **プラグインマネージャー** — Lazy がインストール済みプラグインと読み込み状態を表示。 |
| [![言語ツールマネージャー](language_tools.png)](language_tools.png) | **言語ツールマネージャー** — Mason がインストール済み・利用可能な言語ツールを表示。 |
| [![デバッグ用パネル（実行中のセッションなし）](debug.png)](debug.png) | **デバッグ用パネル（実行中のセッションなし）** — Python コードの周囲にデバッグ用パネルを配置。実行中のセッションはなし。 |

## AI ワークスペース

| プレビュー | 機能 |
| --- | --- |
| [![Claude セッションの配置（初期設定画面）](claude_sessions.png)](claude_sessions.png) | **Claude セッションの配置（初期設定画面）** — Claude ターミナルを上下に 2 個配置。初期設定画面で、タスクは未実行。 |
| [![Codex セッションの配置（空のプレビュー）](codex_sessions.png)](codex_sessions.png) | **Codex セッションの配置（空のプレビュー）** — 上下に 2 個のターミナルバッファを配置。プレビューは空の状態。 |

## 日本語執筆プロファイル

| プレビュー | 機能 |
| --- | --- |
| [![日本語学習ダッシュボード](japanese_dashboard.png)](japanese_dashboard.png) | **日本語学習ダッシュボード** — 日記、単語、参考資料、復習の学習ショートカット。 |
| [![かな一覧](japanese_kana.png)](japanese_kana.png) | **かな一覧** — ひらがな、カタカナ、ローマ字を一覧表で表示。 |
| [![漢字一覧](japanese_kanji.png)](japanese_kanji.png) | **漢字一覧** — 小学 1 年生の漢字を、読み方の例と英語の意味付きで表示。 |
| [![日本語の作文](japanese_writing.png)](japanese_writing.png) | **日本語の作文** — 日本語の作文例と、単語表・練習チェックリスト。 |
