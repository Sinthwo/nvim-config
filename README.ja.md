# Windows 用 Neovim・WezTerm 設定

**言語：** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | 日本語

> **個人的なメモ：** 現在、フランス語と日本語を勉強しています。

**この設定は Windows 向けです。** Neovim、PowerShell、WezTerm を組み合わせ、コード編集、Git の操作、Python のデバッグを行えます。ファイルエクスプローラー、補完、言語サーバー、Markdown の表示、任意の Obsidian 連携が含まれています。

Azure/Bicep、Terraform、YAML、Bash のサポート、CSV/TSV の表編集、Codex と Claude 専用のセッション、画像・PDF のプレビュー、ターミナルの壁紙にも対応しています。

ソースリポジトリ：[Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config)。

パスは現在の Windows ユーザーに合わせて自動的に解決されるため、ユーザー名や固定のドライブ文字を書き込む必要はありません。

ショートカットの一覧、言語ツールの設定、壁紙、カスタマイズ、トラブルシューティングの詳細は、[Windows ユーザーマニュアル](MANUAL.ja.md)をご覧ください。

<a id="requirements"></a>

## 必要なもの

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 以降**。
- `PATH` から実行できる [Git for Windows](https://git-scm.com/downloads/win)、[fzf](https://github.com/junegunn/fzf)、[ripgrep](https://github.com/BurntSushi/ripgrep)。
- ターミナルの壁紙と Ctrl+Tab 連携には [WezTerm](https://wezterm.org/installation.html) を使用します。これらのターミナル機能がなくても Neovim は動作します。
- 推奨シェルは PowerShell 7 です。Windows PowerShell も Editor Services と CPU 状態表示に対応しています。
- 構文解析には Tree-sitter CLI **0.26.1 以降**、`curl`、`tar`、`PATH` から実行できる C コンパイラが必要です。例えば Developer PowerShell で利用する MSVC、または Clang を使用できます。これらは[固定された Tree-sitter のバージョンの要件](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md)に対応しています。
- マニュアルに記載された言語ツールに応じて、Python、Node.js/npm、JDK が必要です。アイコンを表示するための Nerd Font は任意です。

<a id="install-on-windows"></a>

## Windows へのインストール

このリポジトリをダウンロードするか、PowerShell でクローンしてください。

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```
Neovim を閉じ、リポジトリのフォルダーで PowerShell を開いて、次のコマンドを実行してください。既存の設定がある場合、新しいファイルをコピーする前に、日時付きのバックアップへ移動します。インストール済みのプラグインデータは保持されます。

```powershell
# Ask Neovim for its actual config directory, including environment overrides.
$nvimDir = (& nvim --headless -u NONE -i NONE -n --cmd 'lua io.write(vim.fn.stdpath("config"))' +qa).Trim()
if ($LASTEXITCODE -ne 0 -or -not $nvimDir) { throw 'Could not find the Neovim config directory.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
if (Test-Path -LiteralPath $nvimDir) {
    Move-Item -LiteralPath $nvimDir -Destination "$nvimDir.backup-$stamp"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $nvimDir) -Force | Out-Null
Copy-Item -LiteralPath '.\nvim' -Destination $nvimDir -Recurse

# Optional: install the companion WezTerm configuration.
$weztermFile = Join-Path $HOME '.wezterm.lua'
if (Test-Path -LiteralPath $weztermFile) {
    Move-Item -LiteralPath $weztermFile -Destination "$weztermFile.backup-$stamp"
}
Copy-Item -LiteralPath '.\WezTerminal-Config\.wezterm.lua' -Destination $weztermFile
```
通常、Neovim は `$env:LOCALAPPDATA\nvim` を使用し、WezTerm は `$HOME\.wezterm.lua` を読み込みます。WezTerm を再起動して `nvim` を起動し、最初のプラグインとツールのダウンロードが完了するまで待ってください。ソースファイルを開くと、言語サーバーのインストールが始まります。初回インストール後に Neovim を再起動し、`:checkhealth` と `:Mason` を実行してください。

<a id="useful-shortcuts"></a>

## 便利なショートカット

リーダーキーは **Space** です。表のキーを順番に押してください。例えば `Space f f` はファイル選択を開きます。Space を押して待つと、Which-Key のヘルプが表示されます。

| キー | 操作 |
| --- | --- |
| Ctrl+S | 現在のファイルを保存 |
| Ctrl+B | ファイルエクスプローラーを切り替え |
| Ctrl+P / Space f f | ファイルを検索 |
| Space f g | プロジェクト内のテキストを検索 |
| Ctrl+Tab / Ctrl+Shift+Tab | WezTerm で次 / 前のファイルへ移動 |
| Space b c | 現在のファイルを閉じる |
| Space c f | 現在のファイルを整形 |
| Space g g | Git の状態を開く |
| Space u b | ターミナルの背景を選択 |
| Space t t | プロジェクトのターミナルを切り替え |
| Space c v | CSV/TSV の表表示を切り替え |
| Space z t | Azure 用のプロジェクトターミナルを開く |

`:Codex 8` または `:Claude 8` を使うと、専用の Neovim タブに独立した CLI セッションを 8 個開けます。画像や PDF を開くと、別の WezTerm プレビュータブが作成されます。これらの機能を使う前に、必要な外部ツールをインストールしてください。[マニュアル](MANUAL.ja.md#ai-session-workspaces)と[クラウド設定ガイド](nvim/SETUP-CLOUD-TOOLS.ja.md)をご覧ください。

<a id="files-and-sharing"></a>

## ファイルと共有

- `nvim/` は、インストールする Neovim 設定です。
- `WezTerminal-Config/.wezterm.lua` は、Windows ターミナル用の補助設定です。
- [MANUAL.md](MANUAL.ja.md) には、設定済みの機能とローカル設定の説明があります。
- `nvim/lazy-lock.json` はプラグインのリビジョンを記録します。設定を共有するときも保持してください。

壁紙の選択には、画像フォルダーからの相対パスを使用します。Git は選択ファイル、ログ、一時ファイル、ローカル環境ファイル、Terraform の状態ファイルとプランファイルを無視します。個人用のパスは、`OBSIDIAN_VAULT` や `NVIM_BACKGROUND_DIR` などのローカル環境変数で設定してください。

壁紙コレクションの入れ替えに伴い、[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) の画像は削除されました。現在の画像の出典は[壁紙のクレジット](nvim/backgrounds/CREDITS.ja.md)に記載されています。

新しい変更を共有する前に、[検証コマンド](MANUAL.ja.md#validate-the-configuration)を実行し、追加した個人用のカスタマイズを確認してください。
