# Windows setup for cloud, AI, and image tools

Use this guide to install the optional cloud, AI, and image tools used by the
configuration. Start with the [installation README](../README.md), then see
the [Windows manual](../MANUAL.md) for everyday commands and shortcuts.

## Before first launch

Install the core tools listed in the README. After installing command-line
tools, open a new PowerShell or WezTerm window so Neovim picks up the updated
`PATH`. Open a source file to start language-server installation. Let the
downloads finish, restart Neovim, and check `:Lazy`, `:Mason`, `:checkhealth`,
and `:ConformInfo`.

You can also install the additional Mason packages manually:

```vim
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```

Tree-sitter installs the `bicep`, `csv`, `hcl`, `terraform`, and `tsv` parsers
alongside the existing language parsers. Neovim retries parser installation
after Mason finishes installing its tools. A working C compiler and the
Tree-sitter CLI are required.

## Bicep language server

Install the .NET SDK required by the Bicep language-server package, then install
Microsoft's global tool:

```powershell
dotnet --info
dotnet tool install --global Azure.Bicep.LangServer
Get-Command bicep-ls
```

These commands follow the [official Bicep language-server instructions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#bicep-language-server-net-tool).
Neovim finds the installed `bicep-ls` command through `PATH`. Restart Neovim
after installation. To update an existing installation, use
`dotnet tool update --global Azure.Bicep.LangServer`.

Open a `.bicep` or `.bicepparam` file and use the normal LSP shortcuts: `K`, `gd`,
`gr`, F2, Space c a, and Space c d. Installing Bicep CLI or running `az bicep`
alone does not install this language server.

## Terraform, YAML, Azure Pipelines, and Bash

- **Terraform:** Mason installs terraform-ls. Install the Terraform CLI separately
  following [HashiCorp's installation guide](https://developer.hashicorp.com/terraform/install).
  Check `terraform version`. `.tf` and `.tfvars` files have completion and
  diagnostics; Space c f formats them with `terraform fmt`.
- **YAML:** Mason installs yaml-language-server; Space c f uses Prettier.
- **Azure Pipelines:** Mason installs Microsoft's
  [Azure Pipelines language server](https://github.com/microsoft/azure-pipelines-language-server).
  It is enabled for workspaces with `azure-pipelines.yml` or `azure-pipelines.yaml`,
  using the Microsoft pipeline schema. Node.js/npm are required.
- **Bash:** Mason installs bash-language-server and shfmt. Space c f formats shell
  files. Install a Bash runtime separately when you want to execute scripts.

The full language table and keybindings are in the
[manual](../MANUAL.md#language-support-and-formatting).

## Azure CLI

Install Azure CLI with Windows Package Manager:

```powershell
winget install --exact --id Microsoft.AzureCLI
```

Restart WezTerm, then check `az version`. This command follows
[Microsoft's Windows installation guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows).

| Command | Keys | Runs |
| --- | --- | --- |
| `:AzureTerminal` | Space z t | A terminal at the project root |
| `:AzureLogin` | Space z l | `az login` |
| `:AzureAccount` | Space z a | `az account show -o table` |
| `:AzureGroups` | Space z g | `az group list -o table` |
| `:AzureResources` | Space z r | `az resource list -o table` |

These commands open a Snacks terminal at the project root. Sign in with
`:AzureLogin`, then use the account, group, and resource commands to inspect
your Azure environment.

## Azure PowerShell

Use PowerShell 7. Following
[Microsoft's Az installation guide](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell),
install the module for your current account:

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
Get-Module -ListAvailable -Name Az
```

`:AzurePowerShell` or Space z p opens PowerShell 7 and imports Az. If the module
is missing, it shows the installation command. Sign in and check your context:

```powershell
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
```

The configuration finds PowerShell through `PATH` and `ProgramFiles`.
PowerShell language support uses Editor Services installed by Mason.

## Codex and Claude workspaces

Install the CLIs and sign in by following the
[official Codex CLI documentation](https://learn.chatgpt.com/docs/codex/cli) and
[Claude Code setup guide](https://code.claude.com/docs/en/setup).
Check `codex --version` and `claude --version` before starting Neovim.

`:Codex 1` through `:Codex 8` and `:Claude 1` through `:Claude 8` create
Neovim tabs containing only terminal sessions. Your original coding tab stays
open. Use `gt` and `gT` to switch tabs, and press Esc twice to leave terminal input mode.
`:CodexEnd` / `:ClaudeEnd` close the corresponding workspace tabs.

Interactive aliases such as `:Codex_8`, `:Claude_8`, `:Codex_End`, and
`:Claude_End` are supported. Use valid commands without underscores in scripts.
See the [manual](../MANUAL.md#ai-session-workspaces) for layout and navigation.

## CSV and TSV

csvview.nvim enables an aligned table display when you open a CSV/TSV file.
Space c v toggles it; `:CsvViewInfo` reports the delimiter and header.
Tab and Shift+Tab keep their usual behavior. See the
[manual](../MANUAL.md#csv-and-tsv-tables) and
[plugin documentation](https://github.com/hat0uma/csvview.nvim).

## Images and PDF files

Images and PDFs open in separate WezTerm tabs using **`wezterm imgcat`**.
PNG, JPG/JPEG, and GIF open directly. WebP, AVIF, SVG, BMP, TIFF, and PDF need
[ImageMagick for Windows](https://imagemagick.org/script/download.php#windows).
Check the converter with `magick -version`. PDF previews show the first page
and may also require Ghostscript and an ImageMagick policy that permits PDF reading.

Run Neovim inside WezTerm with `wezterm.exe` in `PATH`. Opening a supported
image or PDF from the explorer opens a preview and returns you to your code.
You can also use `:ImagePreview path/to/image.jpg`, `:ImagePreviewClose`, and
`:ImagePreviewCloseAll`. Earlier previews remain open until closed. Neovim
cleans up its preview tabs and temporary files on exit. See the
[manual](../MANUAL.md#image-and-pdf-previews) and
[WezTerm imgcat reference](https://wezterm.org/cli/imgcat.html).

## Wallpapers and local settings

The wallpaper picker searches the image folder and its subfolders, then saves
your choice as a relative path. Both Neovim and WezTerm use `NVIM_BACKGROUND_DIR`
when it is set. Cancelling keeps your previous choice; a missing image restores
the normal terminal appearance. See the
[manual](../MANUAL.md#wezterm-and-wallpapers) for custom folder setup and the
[wallpaper credits](backgrounds/CREDITS.md) for image sources.

Keep private paths in local environment variables such as `OBSIDIAN_VAULT`.
Git ignores wallpaper selections, logs, `.env` files, Terraform state and plan
files, and local validation backups. Review manually created archives before
sharing them, since Git ignore rules do not filter their contents.

## Optional Azure Functions debugging

The included debugger supports Python. To add debugging for .NET isolated
Azure Functions, configure a suitable .NET adapter and install the required
tools, such as Azure Functions Core Tools, a .NET SDK, and netcoredbg.
`azfunc.nvim` is an optional plugin for this workflow.
