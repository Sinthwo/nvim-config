# Windows でのクラウド・AI・画像ツールの設定

**言語：** [English](SETUP-CLOUD-TOOLS.md) | [Français](SETUP-CLOUD-TOOLS.fr.md) | [Deutsch](SETUP-CLOUD-TOOLS.de.md) | 日本語

このガイドでは、設定で使う任意のクラウド、AI、画像ツールをインストールします。まず[インストール README](../README.ja.md)を読み、日常のコマンドとショートカットは [Windows マニュアル](../MANUAL.ja.md)で確認してください。

<a id="before-first-launch"></a>

## 初回起動の前に

README に記載された基本ツールをインストールしてください。コマンドラインツールを追加した後は、新しい PowerShell または WezTerm ウィンドウを開き、更新された `PATH` を Neovim に反映させます。ソースファイルを開くと言語サーバーのインストールが始まります。ダウンロード完了後に Neovim を再起動し、`:Lazy`、`:Mason`、`:checkhealth`、`:ConformInfo` を確認してください。

追加の Mason パッケージは手動でもインストールできます。

```vim
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
Tree-sitter は既存の言語パーサーに加え、`bicep`、`csv`、`hcl`、`terraform`、`tsv` をインストールします。Mason のツールインストール完了後、Neovim はパーサーのインストールを再試行します。動作する C コンパイラと Tree-sitter CLI が必要です。

<a id="bicep-language-server"></a>

## Bicep 言語サーバー

Bicep 言語サーバーパッケージが必要とする .NET SDK をインストールし、Microsoft のグローバルツールを追加します。

```powershell
dotnet --info
dotnet tool install --global Azure.Bicep.LangServer
Get-Command bicep-ls
```
これらは [Bicep 言語サーバーの公式手順](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#bicep-language-server-net-tool)に沿ったコマンドです。Neovim は `PATH` から `bicep-ls` を見つけます。インストール後は Neovim を再起動してください。更新には `dotnet tool update --global Azure.Bicep.LangServer` を使います。

`.bicep` または `.bicepparam` を開き、通常の LSP キー `K`、`gd`、`gr`、F2、Space c a、Space c d を使用します。Bicep CLI のインストールや `az bicep` の実行だけでは、この言語サーバーはインストールされません。

<a id="terraform-yaml-azure-pipelines-and-bash"></a>

## Terraform・YAML・Azure Pipelines・Bash

- **Terraform：** Mason が terraform-ls をインストールします。Terraform CLI は [HashiCorp の手順](https://developer.hashicorp.com/terraform/install)に従って別途インストールしてください。`terraform version` で確認します。`.tf` と `.tfvars` には補完と診断があり、Space c f で `terraform fmt` による整形を行います。
- **YAML：** Mason が yaml-language-server をインストールし、Space c f は Prettier を使います。
- **Azure Pipelines：** Mason が Microsoft の [Azure Pipelines 言語サーバー](https://github.com/microsoft/azure-pipelines-language-server)をインストールします。`azure-pipelines.yml` または `azure-pipelines.yaml` があるワークスペースで有効になり、Microsoft のパイプラインスキーマを使います。Node.js/npm が必要です。
- **Bash：** Mason が bash-language-server と shfmt をインストールします。Space c f でシェルファイルを整形します。スクリプト実行には Bash 環境を別途インストールしてください。

言語一覧とキーバインドは[マニュアル](../MANUAL.ja.md#language-support-and-formatting)にあります。

<a id="azure-cli"></a>

## Azure CLI

Windows Package Manager で Azure CLI をインストールします。

```powershell
winget install --exact --id Microsoft.AzureCLI
```
WezTerm を再起動して `az version` を確認してください。このコマンドは [Microsoft の Windows インストールガイド](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows)に従っています。

| コマンド | キー | 実行内容 |
| --- | --- | --- |
| `:AzureTerminal` | Space z t | プロジェクトルートのターミナル |
| `:AzureLogin` | Space z l | `az login` |
| `:AzureAccount` | Space z a | `az account show -o table` |
| `:AzureGroups` | Space z g | `az group list -o table` |
| `:AzureResources` | Space z r | `az resource list -o table` |

各コマンドはプロジェクトルートに Snacks ターミナルを開きます。`:AzureLogin` でサインインし、アカウント、グループ、リソースのコマンドで Azure 環境を確認してください。

<a id="azure-powershell"></a>

## Azure PowerShell

PowerShell 7 を使用してください。[Microsoft の Az インストールガイド](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell)に従い、現在のアカウントにモジュールをインストールします。

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
Get-Module -ListAvailable -Name Az
```
`:AzurePowerShell` または Space z p は PowerShell 7 を開き、Az を読み込みます。モジュールがない場合はインストールコマンドを表示します。サインインしてコンテキストを確認してください。

```powershell
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
```
設定は `PATH` と `ProgramFiles` から PowerShell を検出します。PowerShell の言語サポートは、Mason がインストールした Editor Services を使用します。

<a id="codex-and-claude-workspaces"></a>

## Codex と Claude のワークスペース

[Codex CLI の公式ドキュメント](https://learn.chatgpt.com/docs/codex/cli)と [Claude Code の設定ガイド](https://code.claude.com/docs/en/setup)に従い、CLI をインストールしてサインインしてください。Neovim 起動前に `codex --version` と `claude --version` を確認します。

`:Codex 1` から `:Codex 8`、`:Claude 1` から `:Claude 8` は、ターミナルセッションだけを含む Neovim タブを作ります。元のコードタブは開いたままです。`gt` と `gT` で移動し、Esc を 2 回押すとターミナル入力を終了します。`:CodexEnd` / `:ClaudeEnd` は対応するワークスペースタブを閉じます。

対話用の別名 `:Codex_8`、`:Claude_8`、`:Codex_End`、`:Claude_End` にも対応します。スクリプトではアンダースコアのない正規のコマンドを使ってください。配置と移動は[マニュアル](../MANUAL.ja.md#ai-session-workspaces)をご覧ください。

<a id="csv-and-tsv"></a>

## CSV と TSV

CSV/TSV を開くと csvview.nvim が整列した表表示を有効にします。Space c v で切り替え、`:CsvViewInfo` で区切り文字とヘッダーを確認します。Tab と Shift+Tab の動作は変わりません。[マニュアル](../MANUAL.ja.md#csv-and-tsv-tables)と[プラグインのドキュメント](https://github.com/hat0uma/csvview.nvim)をご覧ください。

<a id="images-and-pdf-files"></a>

## 画像と PDF ファイル

画像と PDF は **`wezterm imgcat`** を使って別の WezTerm タブで開きます。PNG、JPG/JPEG、GIF は直接表示できます。WebP、AVIF、SVG、BMP、TIFF、PDF には [Windows 用 ImageMagick](https://imagemagick.org/script/download.php#windows) が必要です。`magick -version` で確認してください。PDF プレビューは最初のページを表示し、Ghostscript と PDF 読み込みを許可する ImageMagick ポリシーが必要な場合があります。

`PATH` に `wezterm.exe` がある状態で、WezTerm 内から Neovim を実行してください。エクスプローラーで対応画像や PDF を開くとプレビューが作成され、コードに戻ります。`:ImagePreview path/to/image.jpg`、`:ImagePreviewClose`、`:ImagePreviewCloseAll` も使えます。以前のプレビューは閉じるまで残ります。終了時には Neovim がプレビュータブと一時ファイルを片付けます。[マニュアル](../MANUAL.ja.md#image-and-pdf-previews)と [WezTerm imgcat リファレンス](https://wezterm.org/cli/imgcat.html)をご覧ください。

<a id="wallpapers-and-local-settings"></a>

## 壁紙とローカル設定

壁紙選択は画像フォルダーとサブフォルダーを検索し、選択を相対パスで保存します。`NVIM_BACKGROUND_DIR` を設定すると、Neovim と WezTerm の両方が使用します。キャンセルは以前の選択を保持し、画像がない場合は通常のターミナル表示に戻ります。独自フォルダーは[マニュアル](../MANUAL.ja.md#wezterm-and-wallpapers)、画像の出典は[壁紙クレジット](backgrounds/CREDITS.ja.md)をご覧ください。

非公開のパスは `OBSIDIAN_VAULT` などのローカル環境変数に保存してください。Git は壁紙選択、ログ、`.env`、Terraform の状態・プランファイル、ローカル検証バックアップを無視します。手動作成したアーカイブの内容は Git の除外規則で除外されないため、共有前に確認してください。

<a id="optional-azure-functions-debugging"></a>

## 任意の Azure Functions デバッグ

付属のデバッガーは Python に対応しています。.NET 分離プロセスの Azure Functions をデバッグするには、適切な .NET アダプターを設定し、Azure Functions Core Tools、.NET SDK、netcoredbg などの必要ツールをインストールしてください。`azfunc.nvim` は、この作業に使える任意のプラグインです。
