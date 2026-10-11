# Windows ユーザーマニュアル

**言語：** [English](MANUAL.md) | [Français](MANUAL.fr.md) | [Deutsch](MANUAL.de.md) | 日本語

**この Neovim・WezTerm 設定は Windows 向けです。** インストール、日常のショートカット、任意のツール、カスタマイズについて説明します。例では PowerShell を使い、現在のユーザーに合わせてパスを解決します。

<a id="contents"></a>

## 目次

- [インストールと初回起動](#installation-and-first-launch)
- [編集とショートカット](#editing-and-shortcuts)
- [ファイル検索とエクスプローラー](#finding-files-and-using-the-explorer)
- [言語サポートと整形](#language-support-and-formatting)
- [Python のデバッグ](#python-debugging)
- [Git とプロジェクトターミナル](#git-and-project-terminals)
- [AI セッションのワークスペース](#ai-session-workspaces)
- [Azure とクラウドツール](#azure-and-cloud-tools)
- [CSV・TSV の表](#csv-and-tsv-tables)
- [画像・PDF のプレビュー](#image-and-pdf-previews)
- [Markdown と Obsidian](#markdown-and-obsidian)
- [WezTerm と壁紙](#wezterm-and-wallpapers)
- [カスタマイズとプライバシー](#customization-and-privacy)
- [プラグイン管理](#plugin-management)
- [トラブルシューティング](#troubleshooting)
- [設定の検証](#validate-the-configuration)

<a id="installation-and-first-launch"></a>

## インストールと初回起動

[README のインストール手順](README.ja.md#install-on-windows)に従ってください。コピーコマンドは Neovim の設定ディレクトリに直接ファイルを配置します。その中に余分な `nvim` フォルダーが作成されていないことを確認してください。初回起動時は、プラグインと言語ツールのダウンロードにインターネット接続が必要です。

コマンドラインツールをインストールした後は、新しい PowerShell ウィンドウを開き、更新された `PATH` を反映させてください。基本ツールが利用できるか確認します。

```powershell
nvim --version
git --version
fzf --version
rg --version
wezterm --version
```
固定された Tree-sitter のバージョンは、Neovim 0.12 以降、Tree-sitter CLI 0.26.1 以降、`curl`、`tar`、C コンパイラを[必要とします](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md)。Mason が CLI を自動インストールします。コンパイラは別途インストールしてください。MSVC を使用する場合は Developer PowerShell から WezTerm を起動し、Neovim がコンパイラと環境設定を見つけられるようにします。

言語サーバーのインストールは、ソースファイルを開くと始まります。整形ツールと debugpy は起動直後からインストールされます。`:Lazy` と `:Mason` に完了が表示されるまで初回のセッションを開いたままにし、その後 Neovim を再起動してください。Mason のツールインストールが終わると、Neovim はパーサーのインストールを再試行します。

次のコマンドで設定を確認してください。

```vim
:checkhealth
:Mason
:ConformInfo
:messages
```
<a id="editing-and-shortcuts"></a>

## 編集とショートカット

Neovim には、移動とコマンド用のノーマルモード、文字入力用の挿入モード、範囲選択用のビジュアルモードがあります。`i` で入力を開始し、`Esc` でノーマルモードに戻り、`v` で選択します。ノーマルモードで `:` を入力するとコマンドを実行できます。

リーダーキーは **Space**、ローカルリーダーは **バックスラッシュ** です。`Space b c` は、ノーマルモードで順番にキーを押すことを意味します。大文字と小文字は区別されます。Space を押して待つと、Which-Key が利用可能なショートカットを表示します。

| キーまたはコマンド | 操作 |
| --- | --- |
| Ctrl+S | ノーマルモードまたは挿入モードで保存 |
| `:w` / `:q` / `:wq` | 保存 / ウィンドウを閉じる / 保存して閉じる |
| Esc | ノーマルモードで検索結果の強調表示を消す |
| `/text`、続いて `n` / `N` | 検索、次 / 前の一致箇所 |
| `u` / Ctrl+R | 元に戻す / やり直す |
| Ctrl+H / J / K / L | 左 / 下 / 上 / 右の分割へ移動 |
| Space s v / Space s h | 縦 / 横に分割 |
| Space s c | 現在の分割を閉じる |
| Ctrl+Tab / Ctrl+Shift+Tab | WezTerm 経由で次 / 前のバッファへ移動 |
| Space b n / Space b p | リーダーキーで次 / 前のバッファへ移動 |
| Space b P | 表示されたラベルでバッファを選択 |
| Space b c | 現在のバッファを閉じる |
| Space b o | 他のバッファを閉じる。未保存のバッファは保持 |
| Space b l / Space b r | 左 / 右のバッファを閉じる |
| Space u u | 変更履歴のツリー表示を切り替え |
| Space u z | Zen モードを切り替え |
| Space u n | 通知履歴を表示 |

上部のタブは **バッファ** を表し、通常は開いているファイルです。WezTerm には別のターミナルタブがあります。確認表示や閉じる操作の拒否を避けるため、変更したファイルは閉じる前に保存してください。

補完には Blink の [super-tab プリセット](https://cmp.saghen.dev/configuration/keymap)を使用します。Tab は候補を確定するかスニペット内を進み、Shift+Tab はスニペット内を戻ります。Ctrl+Space で補完を開き、Ctrl+N/P で候補を選択し、Ctrl+E でメニューを閉じます。少し待つとドキュメントが自動表示されます。括弧の自動ペア入力と、囲み文字の編集も有効です。

<a id="finding-files-and-using-the-explorer"></a>

## ファイル検索とエクスプローラー

| キー | 操作 |
| --- | --- |
| Ctrl+P / Space f f | ファイルを検索 |
| Ctrl+Shift+F / Space f g | プロジェクト内のテキストを検索 |
| Space f b | 開いているバッファを選択 |
| Space f r | 最近開いたファイルを選択 |
| Space f s / Space f S | 言語サーバーによる文書 / ワークスペースのシンボル |
| Space f t | TODO コメントを検索 |
| `]t` / `[t` | 次 / 前の TODO コメント |
| Ctrl+B | ファイルエクスプローラーを開閉 |

エクスプローラーでは Enter で項目を開き、`v` または Ctrl+V で縦に、`s` または Ctrl+S で横に分割します。Ctrl+B はエクスプローラーを閉じます。そのため Ctrl+S は、エクスプローラーでは分割、エディターでは保存という 2 つの役割があります。

エクスプローラーは現在のファイルに追従し、隠しファイルと Git が無視するファイルも表示します。ファイル選択は現在の作業ディレクトリを検索します。プロジェクトフォルダーから Neovim を起動するか、`:cd` で移動してください。Windows のテキスト検索には ripgrep が必要です。[fzf-lua の Windows 向け説明](https://github.com/ibhagwan/fzf-lua/blob/main/README-Win.md)をご覧ください。

<a id="language-support-and-formatting"></a>

## 言語サポートと整形

Mason は Neovim のデータディレクトリにツールをインストールします。対応言語とツールは次のとおりです。

| 言語または機能 | ツール | Neovim 外で必要なもの |
| --- | --- | --- |
| Python | BasedPyright、Ruff、debugpy | Python。BasedPyright には Node.js/npm |
| PowerShell | PowerShell Editor Services | PowerShell。推奨はバージョン 7 |
| Java | jdtls | サーバーには JDK 21+、起動には Python 3.9+ |
| Lua | Lua 言語サーバー、StyLua | Mason が管理する実行ファイル |
| JSON / YAML の整形 | Prettier | Node.js/npm |
| YAML / Azure Pipelines | yamlls、azure_pipelines_ls | Node.js/npm |
| Bash / シェルスクリプト | bashls、shfmt | サーバーには Node.js/npm、実行には Bash |
| Terraform / HCL | terraformls、terraform_fmt | 整形と検証には Terraform CLI |
| Azure Bicep / パラメーター | bicep-ls | .NET SDK と別途インストールする Bicep 言語サーバー |
| CSV / TSV | csvview.nvim と構文パーサー | 外部サーバーは不要 |
| 構文の強調表示 | Tree-sitter パーサー | Tree-sitter CLI、curl、tar、C コンパイラ |

Java サーバーの要件は [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration)をご覧ください。プロジェクト自体は別の Java バージョンを対象にできます。Maven・Gradle プロジェクトは、単独の Java ファイルより充実したサポートがあります。

`:Mason` でインストール状況を確認できます。設定済みのツールを手動でインストールすることも可能です。

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
言語サーバーをインストールしたら Neovim を再起動してください。PowerShell Editor Services には PowerShell の実行ファイルと Mason のサービススクリプトが必要です。jdtls がない場合は Java の通知が表示されます。

| キー | 言語サーバーの操作 |
| --- | --- |
| `gd` / `gD` | 定義 / 宣言 |
| `gi` / `gr` | 実装 / 参照 |
| `K` | ホバーのドキュメント |
| F2 | シンボルの名前変更 |
| Space c a | ノーマルまたはビジュアルモードのコードアクション |
| Space c d | 現在の行の診断 |
| `]d` / `[d` | 次 / 前の診断 |
| Space x x | プロジェクトの診断表示を切り替え |
| Space x X | 現在のバッファの診断表示を切り替え |
| Space x s | シンボルパネルを切り替え |

これらは言語サーバーがファイルに接続されているときに使えます。`:checkhealth vim.lsp` でサーバーを確認し、`:messages` で起動エラーを確認してください。

整形は **手動** で、Space c f を押します。Python は Ruff、Lua は StyLua、JSON/YAML は Prettier、Bash は shfmt、Terraform は `terraform fmt` を使用します。他の言語は、利用可能な場合に接続済みの言語サーバーの整形機能を使用します。保存時の自動整形は行いません。`:ConformInfo` で現在のファイルに利用できる整形ツールを確認してください。

Java 専用の操作は、Space j o で import の整理、Space j v で変数の抽出、Space j c で定数の抽出です。同名のプロジェクトフォルダーでも、各 Java プロジェクトに専用のワークスペースキャッシュがあります。新しいキャッシュを初めて使う際、jdtls がプロジェクトを索引化する場合があります。

<a id="python-debugging"></a>

## Python のデバッグ

Python ファイルを開き、Mason で debugpy のインストール完了を確認してください。アダプターは Mason の debugpy インタープリターを使用します。アプリケーション用インタープリターについては、Neovim 起動前にプロジェクトの仮想環境を有効にするか、必要に応じてローカル設定で `require("dap-python").resolve_python` を指定してください。

| キー | 操作 |
| --- | --- |
| F9 | ブレークポイントを切り替え |
| F5 | デバッグを開始 / 続行 |
| F10 | ステップオーバー |
| F11 / Shift+F11 | ステップイン / ステップアウト |
| Space d r | デバッグ REPL を開く |
| Space d t | セッションを終了 |

デバッガー UI はデバッガーとともに読み込まれ、起動または接続時に開き、セッション終了時に閉じます。求められた場合は Python の起動設定を選択してください。この構成は Python デバッグに対応しています。Java のデバッグには追加アダプターと設定が必要です。

<a id="git-and-project-terminals"></a>

## Git とプロジェクトターミナル

| キー | 操作 |
| --- | --- |
| Space g g | Neogit の状態を開く |
| Space g c | コミット画面を開く |
| Space g p / Space g P | push / pull |
| Space g l | Git 履歴を表示 |
| Space g d | 差分を開く |
| Space g H | 現在のファイルの履歴を表示 |
| `]h` / `[h` | 次 / 前の変更ハンク |
| Space g h | ハンクをプレビュー |
| Space g s / Space g r | 現在のハンクをステージ / リセット |
| Space g b | 現在の行の変更者を表示 |
| Space t t | プロジェクトルートのターミナルを切り替え |
| Esc, Esc | ターミナル入力モードを終了 |

ハンクのリセットは、そのハンクの変更を破棄します。push と pull は既存の Git 認証情報とリモート設定を使用します。この Neovim 設定は、Git の作者名やメールアドレスを設定しません。

ターミナルはプロジェクトルートで開きます。ルートは Git、Python プロジェクトファイル、Java ビルドファイル、PowerShell 解析設定、Obsidian 保管庫の目印から判定します。見つからない場合は現在の作業ディレクトリを使用します。

Space a c は Codex、Space a C は Claude Code を起動します。使用前に CLI をインストールしてサインインし、`PATH` からコマンドを実行できることを確認してください。

<a id="ai-session-workspaces"></a>

## AI セッションのワークスペース

外部の [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) または [Claude Code](https://code.claude.com/docs/en/setup) をインストールし、それぞれの案内に従ってサインインしてください。Neovim を起動するターミナルで `codex --version` と `claude --version` を確認します。Space a c と Space a C は、それぞれ 1 つのターミナルを開きます。次のコマンドは、1 つ以上のセッションを含む専用の **Neovim タブページ** を作成します。

| コマンド | 操作 |
| --- | --- |
| `:Codex` / `:Claude` | CLI セッションを 1 つ開く |
| `:Codex 8` / `:Claude 8` | 独立したセッションを 8 個開く |
| `:Codex1` から `:Codex8` | 指定数の Codex セッションを開く |
| `:Claude1` から `:Claude8` | 指定数の Claude セッションを開く |
| `:CodexEnd` / `:ClaudeEnd` | Codex / Claude のワークスペースタブをすべて閉じる |

個数は 1 から 8 の整数です。`:Codex_8`、`:Claude_8`、`:Codex_End`、`:Claude_End` は対話的なコマンドラインの略記です。スクリプトやキーマッピングでは、アンダースコアのない形式を使ってください。

コードは元のタブに残ります。AI タブでは Bufferline がファイルタブを非表示にするため、セッションに集中できます。1 セッションはタブ全体、2 セッションは縦に配置し、3 から 8 セッションは 2 列に配置します。各セッションは現在のプロジェクトルートで開始します。多数のセッションではターミナルを大きくしてください。

`gt` と `gT` で Neovim のタブを切り替えます。ノーマルモードの Ctrl+H/J/K/L で分割間を移動し、`i` でターミナル入力に入ります。Esc を 2 回押すとノーマルモードに戻ります。

`:CodexEnd` は Codex の全ワークスペースタブ、`:ClaudeEnd` は Claude の全ワークスペースタブを閉じます。元のコードタブが開いていれば、どちらもそこへ戻ります。セッションを閉じると、そのプロセスが終了します。サインイン、権限、アカウントの使用量は各 CLI が管理します。

<a id="azure-and-cloud-tools"></a>

## Azure とクラウドツール

Azure CLI、PowerShell Az、Terraform CLI、Bicep 言語サーバーを追加する場合は、[Windows クラウド設定ガイド](nvim/SETUP-CLOUD-TOOLS.ja.md)に従ってください。設定済みの Bash、YAML、Terraform、Azure Pipelines のサーバーは Mason が管理します。

| キー | コマンド | 操作 |
| --- | --- | --- |
| Space z t | `:AzureTerminal` | プロジェクトターミナルを開く |
| Space z l | `:AzureLogin` | `az login` を実行 |
| Space z a | `:AzureAccount` | 現在の Azure アカウントを表示 |
| Space z g | `:AzureGroups` | リソースグループを一覧表示 |
| Space z r | `:AzureResources` | リソースを一覧表示 |
| Space z p | `:AzurePowerShell` | PowerShell 7 を開き、インストール済みなら Az を読み込む |

アカウントとリソースのコマンドは、現在の Azure サインイン状態を使用します。Az がない場合、`:AzurePowerShell` はインストールコマンドを表示します。そのターミナルで `Connect-AzAccount` を使い、Azure PowerShell にサインインしてください。

Bicep は通常の LSP ショートカットで、診断、補完、ホバー、定義、参照、名前変更、コードアクションを操作します。`bicep-ls` のインストール後は Neovim を再起動してください。`.bicepparam` は Bicep パラメーターファイルの種類を使用します。Bicep CLI（`bicep` または `az bicep`）と言語サーバー（`bicep-ls`）は別のツールです。

Azure Pipelines LSP には、`azure-pipelines.yml` または `azure-pipelines.yaml` を含むワークスペースが必要です。Microsoft のスキーマパターンは `Azure-Pipelines/` と `Pipelines/` 内のテンプレートも対象にします。一般的な YAML は yamlls を使用します。Terraform の `.tf` と `.tfvars` は terraform-ls を使い、整形には Terraform CLI が必要です。Bash サポートは `sh` または `bash` と判定されたシェルファイルに適用されます。

プロジェクト判定は `bicepconfig.json`、パイプラインファイル、`.terraform`、`main.tf` も認識します。Azure Functions のデバッグは任意の追加機能で、.NET デバッグアダプターと関連ツールが必要です。

<a id="csv-and-tsv-tables"></a>

## CSV・TSV の表

`.csv` または `.tsv` を開くと、csvview.nvim が枠線付きの整列した表を表示し、固定ヘッダーを自動判定します。CSV はコンマ、TSV はタブを区切りに使用します。`#` または `//` で始まる行はコメントとして扱います。

Space c v / `:CsvViewToggle` で表示を切り替えます。`:CsvViewEnable`、`:CsvViewDisable`、`:CsvViewInfo` は有効化、無効化、情報確認に使います。例：

```vim
:CsvViewEnable delimiter=; header_lnum=1
```
表表示中も通常どおり編集できます。Tab と Shift+Tab の動作は変わりません。

<a id="image-and-pdf-previews"></a>

## 画像・PDF のプレビュー

対応ファイルをエクスプローラーで開くか、`:edit` または `:ImagePreview path/to/image.jpg` を使います。引数がない場合、`:ImagePreview` は現在のファイルを使用します。スペースを含むパスはファイル名補完を使ってください。コマンドはシェルの引用符なしでパス全体を受け付けます。

各プレビューは、ファイル名を付けた別の **WezTerm タブ** で開きます。前のプレビューは開いたままです。Neovim は画像や PDF をバイナリテキストとして表示せず、元のコードバッファに戻ります。

| 形式 | 表示方法 |
| --- | --- |
| PNG、JPG/JPEG、GIF | `wezterm imgcat` で直接表示 |
| WebP、AVIF、SVG、BMP、TIF/TIFF | ImageMagick で一時 PNG に変換 |
| PDF | ImageMagick で 1 ページ目を一時 PNG に変換 |

Neovim は WezTerm 内で実行し、`PATH` に `wezterm.exe` があり、ターミナルから `WEZTERM_PANE` を継承している必要があります。追加形式には [ImageMagick](https://imagemagick.org/script/download.php#windows) が必要です。PDF の読み込みには Ghostscript と、PDF 変換を許可するローカルの ImageMagick ポリシーが必要な場合があります。変換失敗は通知に表示されます。

`:ImagePreviewClose` は最新のプレビューを閉じ、`:ImagePreviewCloseAll` はこの Neovim プロセスが作成した全プレビューを閉じます。WezTerm のタブを閉じるボタンや Ctrl+Shift+W でも個別に閉じられます。Neovim 終了時にはプレビューペインと一時ファイルを片付けます。表示処理は Windows コマンドプロンプト（`cmd.exe`）で実行します。

<a id="markdown-and-obsidian"></a>

## Markdown と Obsidian

Markdown ファイルを開くと表示機能が読み込まれます。Space m r で切り替えます。コードブロックと見出しの背景は透明なため、WezTerm の壁紙が見えます。

Obsidian は任意で、`:Obsidian` コマンドまたはショートカットで読み込みます。保管庫のパスは次の順で選択します。

1. プラグイン読み込み前に指定した `vim.g.nvim_obsidian_vault`。
2. `OBSIDIAN_VAULT` 環境変数。
3. 現在のユーザーに合わせて展開した `~/Documents/Obsidian`。

Neovim 起動前の PowerShell セッションで、既存の保管庫を指定してください。

```powershell
$env:OBSIDIAN_VAULT = Join-Path $HOME 'Documents\Obsidian'
nvim
```
永続的なローカル設定には、Windows のユーザー環境変数、または次のコマンドを使います。

```powershell
[Environment]::SetEnvironmentVariable('OBSIDIAN_VAULT', (Join-Path $HOME 'Documents\Obsidian'), 'User')
```
永続的な環境変数を変更したら WezTerm を再起動してください。これらはローカルのマシン設定なので、共有する Lua ファイルに追加する必要はありません。

| キー | 操作 |
| --- | --- |
| Space o q | ノートを素早く切り替え |
| Space o s | 保管庫を検索 |
| Space o n | ノートを作成 |
| Space o t | 今日のデイリーノートを開く |
| Space o b | バックリンクを表示 |
| Space o c | 保管庫とプラグイン設定を確認 |

一度 `:Obsidian` を実行して連携機能を読み込み、設定した保管庫のノートを開いてください。ノートとタグの補完は、プラグイン内蔵の言語サーバーと Blink を使用します。Markdown 表示は保管庫の外でも動作します。

<a id="wezterm-and-wallpapers"></a>

## WezTerm と壁紙

付属の壁紙の出典は[画像クレジット](nvim/backgrounds/CREDITS.ja.md)に記載されています。壁紙コレクションの入れ替えにより、[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) の画像は削除されました。

補助設定を `$HOME\.wezterm.lua` に配置してください。WezTerm は Tokyo Night の配色を使い、Neovim の使用中は暗くした壁紙を表示します。Neovim 終了時、または選択画像が見つからない場合は通常のターミナル表示に戻ります。ターミナルウィンドウは不透明です。

| キーまたはコマンド | 操作 |
| --- | --- |
| Space u b / `:BackgroundPick` | 画像を選択 |
| Space u B / `:BackgroundFolder` | Windows エクスプローラーで画像フォルダーを開く |
| Ctrl+Tab / Ctrl+Shift+Tab | Neovim 使用中はバッファ、それ以外はターミナルタブを切り替え |
| Alt+Enter | WezTerm の全画面を切り替え |
| Ctrl+Shift+L | WezTerm のデバッグ表示を開く |

選択画面は画像フォルダーとサブフォルダーから PNG、JPG/JPEG、GIF、BMP、WebP を検索します。利用できれば fzf-lua、それ以外は Neovim 内蔵の選択画面を使います。SVG は一覧に表示されません。

既定のフォルダーは Neovim の設定ディレクトリ内の `backgrounds` で、通常は `$env:LOCALAPPDATA\nvim\backgrounds` です。選択は `Magi/01-Magi-Star.jpg` のような相対パスとして `selected-background.txt` に保存されます。キャンセルすると選択を保持します。WezTerm は約 1 秒ごとに選択を確認します。以前の絶対パスもローカルでは使えますが、別の画像を選ぶと相対パスで保存します。

別のフォルダーを使う場合、WezTerm と Neovim の起動前に同じ環境変数を設定してください。

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```
そのフォルダーに画像を置き、WezTerm を再起動して Neovim で選択してください。絶対パス、またはホームからの相対パス `~/...` を使います。両方のアプリケーションに同じ値が必要です。Neovim の `XDG_CONFIG_HOME` や `NVIM_APPNAME` を使用している場合、WezTerm もそれらを利用します。

<a id="customization-and-privacy"></a>

## カスタマイズとプライバシー

Neovim は `stdpath()` で設定、データ、キャッシュのパスを解決します。実際の場所をエディターで確認できます。

```vim
:lua print(vim.fn.stdpath("config"))
:lua print(vim.fn.stdpath("data"))
:lua print(vim.fn.stdpath("cache"))
```
新しいローカルパスには `vim.fn.expand("~/...")`、`vim.fs.joinpath()`、環境変数を使ってください。PowerShell の検出には `PATH`、`ProgramFiles`、`SystemRoot` を使い、固定ドライブやユーザー名は不要です。

基本設定は `nvim/lua/config/options.lua`、編集ショートカットは `nvim/lua/config/keymaps.lua`、プラグイン設定は `nvim/lua/plugins/` にあります。WezTerm の外観、壁紙の明るさ、ターミナルのショートカットは `WezTerminal-Config/.wezterm.lua` で設定します。すべてのアイコンを表示するには、ローカルにインストールした Nerd Font を WezTerm で選んでください。

壁紙を選ぶと相対画像パスを含むローカル選択ファイルが作成されます。Git は選択、ログ、セッション、エディターの一時ファイル、ローカル検証バックアップを無視します。`.env`、`.terraform/`、Terraform の状態・プランファイル、クラッシュログも無視します。非公開の保管庫パスや認証情報はローカル設定に保存してください。

除外規則は未追跡のファイルに適用されます。すでに Git が追跡するファイルは削除せず、手動で作成した ZIP の内容も除外しません。共有ファイル、特に以前の非公開パスを含む可能性があるアーカイブやバックアップを確認してください。

ファイル名、プロジェクト名、最近使ったファイル、バッファのパスはエディターに表示されます。スクリーンショットや画面を共有する際は、この点に注意してください。

コミットの作者名とメールアドレスは Git が管理します。リポジトリ履歴の情報を確認するには次を実行します。

```powershell
git log --all --format='%h %an <%ae>'
```
今後のコミットに公開用の別名と GitHub の noreply アドレスを使用したい場合は、このリポジトリに設定します。2 つのプレースホルダーを自分の値に置き換えてください。

```powershell
git config user.name 'YOUR_PUBLIC_ALIAS'
git config user.email 'YOUR_GITHUB_NOREPLY_EMAIL'
```
実際の noreply アドレスは GitHub のメール設定からコピーしてください。[GitHub のコミット用メールアドレスの説明](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address)をご覧ください。変更は今後のコミットに適用されます。履歴を書き換えない限り、既存のコミットの作者・コミッター情報は変わりません。

<a id="plugin-management"></a>

## プラグイン管理

`:Lazy` でプラグインの状態を確認します。`:Lazy restore` は `lazy-lock.json` に記録されたバージョンに戻します。`:Lazy update` は新しいバージョンをインストールし、ロックファイルを変更する場合があります。設定を共有する際はロックファイルを保持してください。記録のないプラグインは最初に必要になったときにインストールされます。

`:Mason` で言語ツールを確認し、`:MasonUpdate` でレジストリを更新、`:MasonInstall` でパッケージをインストールします。Mason の tool-installer は設定済みの整形ツール、debugpy、Tree-sitter CLI も自動で要求します。

コンパイラが利用できれば、パーサーを明示的にインストールできます。

```vim
:TSInstall bash bicep csv hcl java json lua markdown markdown_inline powershell python query regex terraform toml tsv vim vimdoc yaml
:TSUpdate
```
`TSInstall` は指定パーサーを追加し、`TSUpdate` はプラグイン更新後にインストール済みのパーサーを更新します。強調表示が有効にならない場合はファイルを開き直してください。

<a id="troubleshooting"></a>

## トラブルシューティング

| 症状 | 確認する内容 |
| --- | --- |
| 設定が変わらない | `stdpath("config")` を表示し、二重の `nvim/nvim` フォルダーや環境変数の上書きを確認。 |
| プラグインのインストール失敗 | Git、ネットワーク、`:Lazy`、`:messages` を確認。 |
| ファイル選択やテキスト検索の失敗 | Neovim を起動するターミナルで `fzf --version` と `rg --version` を確認。 |
| アイコンが四角になる | WezTerm に Nerd Font を設定。 |
| 構文の強調表示がない | `:checkhealth nvim-treesitter` を実行し、CLI・コンパイラを確認後、`:TSInstall` を実行してファイルを開き直す。 |
| Python の診断がない | `:Mason` の BasedPyright/Ruff を確認し、インストール後に再起動してプロジェクト環境を有効にする。 |
| PowerShell LSP が無効 | PowerShell Editor Services をインストールし、`pwsh`/`powershell.exe` を確認後、Neovim を再起動。 |
| Java サーバーが起動しない | JDK・Python のバージョン、`:Mason` の jdtls、プラグイン読み込み後の `:JdtShowLogs` を確認。 |
| 整形キーが動作しない | `:ConformInfo` を確認し、整形ツールをインストールして `PATH` を確認。 |
| デバッグ失敗 | `:Mason` の debugpy、アプリ用インタープリター、デバッグ REPL のメッセージを確認。 |
| Obsidian にワークスペースがない | `OBSIDIAN_VAULT` に既存の保管庫を指定し、Neovim を再起動。 |
| 壁紙がない | `$HOME\.wezterm.lua`、画像フォルダー、選択ファイル、両プロセスの `NVIM_BACKGROUND_DIR` を確認。 |
| Ctrl+Tab がターミナルタブを切り替える | WezTerm 内で Neovim を再起動し、Space b n/p と補助設定の読み込みを確認。 |
| グラフィック表示の失敗 | ローカルの WezTerm 設定で `config.front_end = "OpenGL"` を試す。 |
| AI セッションの失敗 | PATH 内の CLI、1 から 8 の整数を確認し、分割数が多い場合はターミナルを大きくする。 |
| スクリプトで AI のアンダースコア略記が失敗 | `Codex8`、`Claude8`、`CodexEnd`、`ClaudeEnd` を使う。アンダースコア付きは対話用の略記。 |
| Bicep LSP がない | PATH 内の `bicep-ls` を確認して再起動。Bicep CLI だけでは不足。 |
| Terraform 整形の失敗 | `terraform version` を確認。Mason の言語サーバーとは別に必要。 |
| Azure ショートカットの失敗 | `az version`、認証・アカウント、`AzurePowerShell` 用の PowerShell 7/Az を確認。 |
| 画像プレビューの失敗 | WezTerm 内で Neovim を実行し、PATH 内の `wezterm` と `:messages` を確認。 |
| 画像・PDF 変換の失敗 | `magick -version` を確認。PDF は Ghostscript と適切なポリシーも必要な場合がある。 |

外部プログラムがない場合は Neovim が通知します。見逃した通知は `:messages` または Space u n で確認できます。

<a id="validate-the-configuration"></a>

## 設定の検証

リポジトリのフォルダーで PowerShell から次を実行してください。プラグインをインストールせず、使用中の Neovim 設定も変更しません。

```powershell
nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
wezterm --config-file '.\WezTerminal-Config\.wezterm.lua' show-keys
```
最初のコマンドは Lua の構文、ドキュメントのリンク、ショートカットを確認します。また、Windows のサンプルプロファイルでのパス処理、壁紙選択、デバッガー読み込み、Obsidian 設定、パーサーインストールの再試行、Java キャッシュ、クラウドツール、AI セッション、プレビューコマンドも検証します。

これらはプラグインの動作を模擬する確認です。対話的な機能は通常の Neovim セッションでも試してください。2 つ目のコマンドは WezTerm 設定を読み込み、キーバインドを表示します。
