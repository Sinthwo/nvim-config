# Windows 用 Neovim・WezTerm 設定

**言語：** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | 日本語

Windows 向けの Neovim・PowerShell・WezTerm 設定です。ファイルエクスプローラー、補完、
言語サーバー、Git ツール、Python のデバッグを利用できます。

オプションでクラウド開発、AI ターミナルセッション、Markdown・Obsidian 連携、日本語作文、
画像プレビュー、壁紙を追加できます。詳しくは [Windows マニュアル](MANUAL.ja.md)をご覧ください。

**クイックリンク：** [Windows へのインストール](#windows-へのインストール) · [最初の動作確認](#最初の動作確認) · [更新と復元](MANUAL.ja.md#更新と復元) · [便利なショートカット](#便利なショートカット) · [オプション機能](#オプション機能) · [ファイルと共有](#ファイルと共有)

## スクリーンショット

| 起動時のダッシュボード | エディターとファイルエクスプローラー |
| --- | --- |
| [![サメのロゴとショートカットがある Neovim のダッシュボード](docs/screenshots/dashboard.png)](docs/screenshots/dashboard.png) | [![ファイルエクスプローラーの横で Lua ファイルを編集する Neovim](docs/screenshots/editor-explorer.png)](docs/screenshots/editor-explorer.png) |

壁紙マネージャーや日本語執筆プロファイルを含む 31 枚の画像は、[機能ギャラリー](docs/screenshots/README.ja.md)で確認できます。

## 必要なもの

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 以降**。
- `PATH` から実行できる [Git for Windows](https://git-scm.com/downloads/win)、[fzf](https://github.com/junegunn/fzf)、[ripgrep](https://github.com/BurntSushi/ripgrep)。
- ターミナルの壁紙と `Ctrl+Tab` 連携には [WezTerm](https://wezterm.org/installation.html) を使用します。これらのターミナル機能がなくても Neovim は動作します。
- 推奨シェルは PowerShell 7 です。Windows PowerShell も Editor Services と CPU 状態表示に対応しています。
- 構文解析には Tree-sitter CLI **0.26.1 以降**、`curl`、`tar`、`PATH` から実行できる C コンパイラが必要です。例えば Developer PowerShell で利用する MSVC、または Clang を使用できます。これらは[固定された Tree-sitter のバージョンの要件](https://github.com/nvim-treesitter/nvim-treesitter/blob/a2f694478be07f89c2d03cc17858a8745a400c4b/README.md)に対応しています。
- マニュアルに記載された言語ツールに応じて、Python、Node.js/npm、JDK が必要です。アイコンを表示するための Nerd Font は任意です。

## Windows へのインストール

このリポジトリをダウンロードするか、PowerShell でクローンしてください。

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```

Neovim を閉じ、リポジトリのフォルダーで PowerShell を開いて、次のコマンドを実行してください。既存の設定がある場合、新しいファイルをコピーする前に、日時付きのバックアップへ移動します。インストール済みのプラグインデータは保持されます。

ファイル操作に失敗するとコマンドは停止します。表示されたバックアップ先を控えてください。
既存の設定を置き換える前に、[更新と復元](MANUAL.ja.md#更新と復元)でローカル設定の引き継ぎ方法を確認してください。

```powershell
# Ask the executable directly, bypassing any PowerShell profile launcher.
$nvimDir = (& nvim.exe --headless -u NONE -i NONE -n --cmd 'lua io.write(vim.fn.stdpath("config"))' +qa).Trim()
if ($LASTEXITCODE -ne 0 -or -not $nvimDir) { throw 'Could not find the Neovim config directory.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$nvimBackup = "$nvimDir.backup-$stamp"
if (Test-Path -LiteralPath $nvimDir) {
    Move-Item -LiteralPath $nvimDir -Destination $nvimBackup -ErrorAction Stop
    Write-Host "Neovim backup: $nvimBackup"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $nvimDir) -Force -ErrorAction Stop | Out-Null
Copy-Item -LiteralPath '.\nvim' -Destination $nvimDir -Recurse -ErrorAction Stop
```

### 任意：WezTerm の設定

WezTerm の設定を置き換える場合だけ、この独立したブロックを実行してください。
既存のファイルは先にバックアップします。

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$weztermFile = Join-Path $HOME '.wezterm.lua'
if (Test-Path -LiteralPath $weztermFile) {
    $weztermBackup = "$weztermFile.backup-$stamp"
    Move-Item -LiteralPath $weztermFile -Destination $weztermBackup -ErrorAction Stop
    Write-Host "WezTerm backup: $weztermBackup"
}
Copy-Item -LiteralPath '.\WezTerminal-Config\.wezterm.lua' -Destination $weztermFile -ErrorAction Stop
```

通常、Neovim は `$env:LOCALAPPDATA\nvim` を使用し、WezTerm は `$HOME\.wezterm.lua` を読み込みます。WezTerm を再起動して `nvim` を起動し、最初のプラグインとツールのダウンロードが完了するまで待ってください。ソースファイルを開くと、言語サーバーのインストールが始まります。初回インストール後に Neovim を再起動し、`:checkhealth` と `:Mason` を実行してください。

## 最初の動作確認

練習用の Git プロジェクトで WezTerm を開き、`nvim README.md` を実行します。
初回ダウンロードの完了後に Neovim を再起動し、同じプロジェクトに戻ってください。
ショートカットはノーマルモード（`Esc`）で、Space の後に各キーを順番に押します。

| 試す操作 | 期待する結果 |
| --- | --- |
| `Space f f`、ファイル名の一部、`Enter` を入力 | ファイル選択から指定したファイルが開きます。 |
| `Space f g` でプロジェクト内にある文字列を検索 | 一致箇所とプレビューが表示され、`Esc` で閉じます。 |
| `i` で少し編集し、`Esc`、`Ctrl+S` を押す | 保存され、未保存の変更を示す印が消えます。 |
| Lua ファイルを開いて `Space c f` を押す | Mason でのインストール完了後、StyLua が整形します。 |
| `Space g g` を押す | Neogit に変更ファイルが表示され、`:close` で戻れます。 |

編集と整形には練習用ファイルを使ってください。動作しない場合は `:messages`、`:Mason`、
`:ConformInfo` と[トラブルシューティング](MANUAL.ja.md#トラブルシューティング)を確認します。
ほかの操作は[マニュアル](MANUAL.ja.md)をご覧ください。

## 便利なショートカット

リーダーキーは **Space** です。表のキーを順番に押してください。例えば `Space f f` はファイル選択を開きます。Space を押して待つと、Which-Key のヘルプが表示されます。

| キー | 操作 |
| --- | --- |
| `Ctrl+S` | 現在のファイルを保存 |
| `Ctrl+B` | ファイルエクスプローラーを切り替え |
| `Ctrl+P` / `Space f f` | ファイルを検索 |
| `Space f g` | プロジェクト内のテキストを検索 |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | WezTerm で次 / 前のファイルへ移動 |
| `Space b c` | 現在のファイルを閉じる |
| `Space c f` | 現在のファイルを整形 |
| `Space g g` | Git の状態を開く |
| `Space u b` | ターミナルの背景を選択 |
| `Space t t` | プロジェクトのターミナルを切り替え |
| `Space c v` | CSV/TSV の表表示を切り替え |
| `Space z t` | Azure 用のプロジェクトターミナルを開く |

`:Codex 8` または `:Claude 8` を使うと、専用の Neovim タブに独立した CLI セッションを 8 個開けます。画像や PDF を開くと、別の WezTerm プレビュータブが作成されます。これらの機能を使う前に、必要な外部ツールをインストールしてください。[マニュアル](MANUAL.ja.md#ai-セッションのワークスペース)と[クラウド設定ガイド](nvim/SETUP-CLOUD-TOOLS.ja.md)をご覧ください。

## オプション機能

`:CodeDiff` または `:MiniDiffOverlay` で変更を確認し、`:InclineToggle` で分割ウィンドウの
ファイル名表示を切り替え、`:Oil` で編集可能なディレクトリを開けます。
`:AICopyPath` または `:AICopyContext` で AI ツール向けのコード参照をコピーできます。
Web と Markdown の整形には、利用可能な prettierd または prettier を使います。
詳細は[更新メモ（英語）](nvim/UPGRADE_NOTES.md)を参照してください。

`Space u b` で壁紙管理を開き、フォルダー参照、お気に入り、ランダム選択、起動モードを使えます。
初期状態では起動時にランダム選択します。Settings の Manual で画像を固定できます。
`Space m p` は Markdown/Mermaid のブラウザープレビューです。

任意の `nvim-jp/` は日本語作文、単語、仮名・漢字練習、Obsidian ノートを追加します。
PowerShell ランチャーは対話的な `nvim` の引数がない場合に Coding/Japanese を選択します。
`nvim-code` と `nvim-jp` は直接起動します。[プロファイルのインストール（英語）](NeovimProfiles/README.md)と
[マニュアル](MANUAL.ja.md#日本語学習プロファイル)を参照してください。
個人設定、お気に入り、起動モードは Git が無視します。

起動時のダッシュボードには、ファイル、検索、プラグイン、ターミナル用のショートカットがあります。
コマンドは[ダッシュボードと通知](MANUAL.ja.md#ダッシュボードと通知)、起動済みセッションの選択と拡大は
[AI セッションのワークスペース](MANUAL.ja.md#ai-セッションのワークスペース)をご覧ください。

## ファイルと共有

- `nvim/` は、インストールする Neovim 設定です。
- `WezTerminal-Config/.wezterm.lua` は、Windows ターミナル用の補助設定です。
- [MANUAL.ja.md](MANUAL.ja.md) には、設定済みの機能とローカル設定の説明があります。
- `nvim/lazy-lock.json` はプラグインのリビジョンを記録します。設定を共有するときも保持してください。

ソースリポジトリ：[Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config)。
パスは現在の Windows ユーザーに合わせて解決されるため、固定のユーザー名やドライブ文字は不要です。

> **個人的なメモ：** 現在、フランス語と日本語を勉強しています。

壁紙の選択には、画像フォルダーからの相対パスを使用します。Git は選択ファイル、ログ、一時ファイル、ローカル環境ファイル、Terraform の状態ファイルとプランファイルを無視します。個人用のパスは、`OBSIDIAN_VAULT` や `NVIM_BACKGROUND_DIR` などのローカル環境変数で設定してください。

現在の画像の出典は[壁紙のクレジット](nvim/backgrounds/CREDITS.ja.md)に記載されています。

新しい変更を共有する前に、[検証コマンド](MANUAL.ja.md#設定の検証)を実行し、追加した個人用のカスタマイズを確認してください。
