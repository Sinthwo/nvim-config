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

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![起動時のダッシュボード](dashboard.png)](dashboard.png) | **起動時のダッシュボード** — サメのロゴと、ファイル・検索・プラグイン・ターミナル用のショートカット。 | `Space u D` · [ガイド](../../MANUAL.ja.md#ダッシュボードと通知) |
| [![エディターとファイルエクスプローラー](editor-explorer.png)](editor-explorer.png) | **エディターとファイルエクスプローラー** — プロジェクトツリーの横で Lua を編集。上部には開いているファイルを表示。 | `Ctrl+B` · [ガイド](../../MANUAL.ja.md#ファイル検索とエクスプローラー) |
| [![ファイル選択](file-picker.png)](file-picker.png) | **ファイル選択** — ファイル名で検索し、選択したファイルをプレビュー。 | `Space f f` · [ガイド](../../MANUAL.ja.md#ファイル検索とエクスプローラー) |
| [![ショートカットの確認](shortcuts.png)](shortcuts.png) | **ショートカットの確認** — Which-Key がリーダーキーのショートカットを用途別に表示。 | `Space` · [ガイド](../../MANUAL.ja.md#編集とショートカット) |
| [![プロジェクト内のテキスト検索](search.png)](search.png) | **プロジェクト内のテキスト検索** — プロジェクト内の検索結果と、選択した行のプレビュー。 | `Space f g` · [ガイド](../../MANUAL.ja.md#ファイル検索とエクスプローラー) |
| [![TODO の検索](todo.png)](todo.png) | **TODO の検索** — TODO の検索結果と、その前後のコードを表示。 | `Space f t` · [ガイド](../../MANUAL.ja.md#ファイル検索とエクスプローラー) |
| [![一時メモ](scratch.png)](scratch.png) | **一時メモ** — コードの横で使えるフローティングメモ。 | `Space u .` · [ガイド](../../MANUAL.ja.md#git-とプロジェクトターミナル) |
| [![通知履歴](notifications.png)](notifications.png) | **通知履歴** — 過去のエディターメッセージを通知履歴にまとめて表示。 | `Space u n` · [ガイド](../../MANUAL.ja.md#ダッシュボードと通知) |
| [![Zen モード](zen.png)](zen.png) | **Zen モード** — 周囲のパネルを隠し、Markdown 文書を中央に表示。 | `Space u z` · [ガイド](../../MANUAL.ja.md#編集とショートカット) |

## 執筆とデータ

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![コード補完](completion.png)](completion.png) | **コード補完** — Lua の補完候補と、選択した項目のドキュメント。 | `Ctrl+Space` · [ガイド](../../MANUAL.ja.md#編集とショートカット) |
| [![言語診断](diagnostics.png)](diagnostics.png) | **言語診断** — Python の型エラーをコード内と診断パネルに表示。 | `Space x x` · [ガイド](../../MANUAL.ja.md#言語サポートと整形) |
| [![Markdown の表示](markdown.png)](markdown.png) | **Markdown の表示** — 見出し、チェックボックス、コールアウト、コード、表を装飾。 | `Space m r` · [ガイド](../../MANUAL.ja.md#markdown-と-obsidian) |
| [![CSV テーブル](csv.png)](csv.png) | **CSV テーブル** — CSV の値を列にそろえて表示し、そのままテキストとして編集。 | `Space c v` · [ガイド](../../MANUAL.ja.md#csvtsv-の表) |
| [![Obsidian ノート](obsidian.png)](obsidian.png) | **Obsidian ノート** — サンプル Vault のノートをクイックスイッチで検索し、内容をプレビュー。 | `Space o q` · [ガイド](../../MANUAL.ja.md#markdown-と-obsidian) |
| [![画像プレビュー](image_preview.png)](image_preview.png) | **画像プレビュー** — 画像を専用の WezTerm プレビュータブに表示。 | `:ImagePreview path/to/image.jpg` · [ガイド](../../MANUAL.ja.md#画像pdf-のプレビュー) |

## Git と履歴

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![Git の状態](git.png)](git.png) | **Git の状態** — Neogit が変更ファイルと未ステージの変更を表示。 | `Space g g` · [ガイド](../../MANUAL.ja.md#git-とプロジェクトターミナル) |
| [![差分の並列表示](diff.png)](diff.png) | **差分の並列表示** — 変更ファイルの一覧と、コードの差分を左右に並べて表示。 | `Space g d` · [ガイド](../../MANUAL.ja.md#git-とプロジェクトターミナル) |
| [![取り消し履歴](undo.png)](undo.png) | **取り消し履歴** — 編集中のバッファの横に取り消し履歴の分岐を表示。 | `Space u u` · [ガイド](../../MANUAL.ja.md#編集とショートカット) |

## ターミナルとツール

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![プロジェクトのターミナル](terminal.png)](terminal.png) | **プロジェクトのターミナル** — コードの下にプロジェクトターミナルを開き、フォルダーの内容を表示。 | `Space t t` · [ガイド](../../MANUAL.ja.md#git-とプロジェクトターミナル) |
| [![フローティングターミナル](floating_terminal.png)](floating_terminal.png) | **フローティングターミナル** — コードを表示したまま、その上にターミナルを開く。 | `Space t f` · [ガイド](../../MANUAL.ja.md#git-とプロジェクトターミナル) |
| [![クラウド設定言語の編集](cloud_languages.png)](cloud_languages.png) | **クラウド設定言語の編集** — Terraform と Azure Pipelines YAML を左右に並べて表示。 | `:vsplit azure-pipelines.yml` · [ガイド](../../MANUAL.ja.md#azure-とクラウドツール) |
| [![壁紙マネージャー](wallpapers.png)](wallpapers.png) | **壁紙マネージャー** — 壁紙マネージャーで画像参照、お気に入り、ランダム選択、起動設定を選択。 | `Space u b` · [ガイド](../../nvim/backgrounds/README.ja.md) |
| [![プラグインマネージャー](plugins.png)](plugins.png) | **プラグインマネージャー** — Lazy がインストール済みプラグインと読み込み状態を表示。 | `:Lazy` · [ガイド](../../MANUAL.ja.md#プラグイン管理) |
| [![言語ツールマネージャー](language_tools.png)](language_tools.png) | **言語ツールマネージャー** — Mason がインストール済み・利用可能な言語ツールを表示。 | `:Mason` · [ガイド](../../MANUAL.ja.md#言語サポートと整形) |
| [![デバッグ用パネル（実行中のセッションなし）](debug.png)](debug.png) | **デバッグ用パネル（実行中のセッションなし）** — Python コードの周囲にデバッグ用パネルを配置。実行中のセッションはなし。 | `F5` · [ガイド](../../MANUAL.ja.md#python-のデバッグ) |

## AI ワークスペース

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![Claude セッションの配置（初期設定画面）](claude_sessions.png)](claude_sessions.png) | **Claude セッションの配置（初期設定画面）** — Claude ターミナルを上下に 2 個配置。初期設定画面で、タスクは未実行。 | `:Claude 2` · [ガイド](../../MANUAL.ja.md#ai-セッションのワークスペース) |
| [![Codex セッションの配置（空のプレビュー）](codex_sessions.png)](codex_sessions.png) | **Codex セッションの配置（空のプレビュー）** — 上下に 2 個のターミナルバッファを配置。プレビューは空の状態。 | `:Codex 2` · [ガイド](../../MANUAL.ja.md#ai-セッションのワークスペース) |

## 日本語執筆プロファイル

| プレビュー | 機能 | 操作とガイド |
| --- | --- | --- |
| [![日本語学習ダッシュボード](japanese_dashboard.png)](japanese_dashboard.png) | **日本語学習ダッシュボード** — 日記、単語、参考資料、復習の学習ショートカット。 | `:JPDashboard` · [ガイド（英語）](../../nvim-jp/JP-HELP.md#commands) |
| [![かな一覧](japanese_kana.png)](japanese_kana.png) | **かな一覧** — ひらがな、カタカナ、ローマ字を一覧表で表示。 | `:JPKanaChart` · [ガイド（英語）](../../nvim-jp/JP-HELP.md#commands) |
| [![漢字一覧](japanese_kanji.png)](japanese_kanji.png) | **漢字一覧** — 小学 1 年生の漢字を、読み方の例と英語の意味付きで表示。 | `:JPKanjiList` · [ガイド（英語）](../../nvim-jp/JP-HELP.md#commands) |
| [![日本語の作文](japanese_writing.png)](japanese_writing.png) | **日本語の作文** — 日本語の作文例と、単語表・練習チェックリスト。 | `:JPWriting` · [ガイド（英語）](../../nvim-jp/JP-HELP.md#commands) |
