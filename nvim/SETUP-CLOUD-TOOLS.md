# Windows setup for cloud, AI, and image tools

This guide supplements the [installation README](../README.md) and
[Windows manual](../MANUAL.md). The Lua configuration supplies integrations;
external tools are installed separately on your own Windows account.

## Before first launch

Install the core prerequisites in the README. Open a new PowerShell/WezTerm
window after installing tools so Neovim inherits their updated `PATH`.
Open source files to trigger Mason's LSP installer, then let installations finish
and restart Neovim. Check `:Lazy`, `:Mason`, `:checkhealth`, and `:ConformInfo`.

Configured additional Mason packages can also be requested explicitly:

```vim
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```

Tree-sitter additionally requests `bicep`, `csv`, `hcl`, `terraform`, and `tsv`
along with the existing parsers. Parser installation retries when Mason's tool
installer finishes. It still requires the Tree-sitter CLI and a working C compiler.

## Bicep language server

Install the .NET SDK required by the Bicep language-server package, then install
Microsoft's global tool:

```powershell
dotnet --info
dotnet tool install --global Azure.Bicep.LangServer
Get-Command bicep-ls
```

This is the [official Bicep language-server installation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#bicep-language-server-net-tool).
The tool exposes `bicep-ls` in `PATH`. Neovim searches for it automatically;
restart Neovim after installing it. An existing tool can be updated with
`dotnet tool update --global Azure.Bicep.LangServer`.

Open `.bicep` or `.bicepparam` and use the normal LSP shortcuts: `K`, `gd`,
`gr`, F2, Space c a, and Space c d. Installing Bicep CLI or running `az bicep`
alone does not install this language server.

## Terraform, YAML, Azure Pipelines, and Bash

- **Terraform:** Mason installs terraform-ls. Install the Terraform CLI separately
  following [HashiCorp's installation guide](https://developer.hashicorp.com/terraform/install).
  Check `terraform version`. `.tf` / `.tfvars` have completion and diagnostics;
  Space c f uses `terraform fmt`. The config does not run `apply` or `destroy`.
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

These commands use the existing Snacks terminal and your own Azure account.
They display account/resource information and leave deployment commands to you.

## Azure PowerShell

Use PowerShell 7. Following
[Microsoft's Az installation guide](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell),
install the module for your current account:

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
Get-Module -ListAvailable -Name Az
```

`:AzurePowerShell` / Space z p opens PowerShell 7, imports Az if present,
and reports the install command if missing. Then authenticate and inspect your
context yourself:

```powershell
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
```

PowerShell is discovered using `PATH` and `ProgramFiles`; no fixed drive or
username is required. The PowerShell LSP continues to use Mason's Editor Services.

## Codex and Claude workspaces

Install/authenticate the CLIs using the
[official Codex CLI documentation](https://learn.chatgpt.com/docs/codex/cli) and
[Claude Code setup guide](https://code.claude.com/docs/en/setup).
Check `codex --version` and `claude --version` before starting Neovim.

`:Codex 1` through `:Codex 8` and `:Claude 1` through `:Claude 8` create
terminal-only Neovim workspace tabs. The original coding tab stays available.
Use `gt` / `gT` to switch tabs and Esc twice to leave terminal input mode.
`:CodexEnd` / `:ClaudeEnd` close the corresponding workspace tabs.

Interactive aliases such as `:Codex_8`, `:Claude_8`, `:Codex_End`, and
`:Claude_End` are supported. Use valid commands without underscores in scripts.
See the [manual](../MANUAL.md#ai-session-workspaces) for layout and navigation.

## CSV and TSV

csvview.nvim enables an aligned table display when you open a CSV/TSV file.
Space c v toggles it; `:CsvViewInfo` reports the delimiter and header.
Tab/Shift+Tab bindings are untouched. See the
[manual](../MANUAL.md#csv-and-tsv-tables) and
[plugin documentation](https://github.com/hat0uma/csvview.nvim).

## Images and PDF files

The current viewer uses **WezTerm's `imgcat` in independent WezTerm tabs**.
Snacks.image is disabled, and image.nvim/Sixel/Kitty plugins are not configured.
PNG, JPG/JPEG, and GIF open directly. WebP, AVIF, SVG, BMP, TIFF, and PDF need
[ImageMagick for Windows](https://imagemagick.org/script/download.php#windows).
Verify the converter with `magick -version`. PDF page 1 conversion may additionally
need Ghostscript and a local ImageMagick policy that allows PDF reading.

Run Neovim inside WezTerm with `wezterm.exe` in `PATH`. Opening a supported
image/PDF from the explorer intercepts its binary contents and opens the viewer.
You can also use `:ImagePreview path/to/image.jpg`, `:ImagePreviewClose`, and
`:ImagePreviewCloseAll`. Earlier previews remain open until closed. Neovim
cleans up its preview tabs and temporary files on exit. See the
[manual](../MANUAL.md#image-and-pdf-previews) and
[WezTerm imgcat reference](https://wezterm.org/cli/imgcat.html).

## Wallpapers and local settings

The background picker searches subfolders recursively and saves a relative
path. Both Neovim and WezTerm honor `NVIM_BACKGROUND_DIR`. Cancelling preserves
the previous choice; a missing image restores normal terminal appearance.
The three mislabeled WebP files now use the correct extension.

The owner removed the previous ThePrimeagen/anime images. Current image sources
are listed in [wallpaper credits](backgrounds/CREDITS.md).

Keep private paths in local environment variables such as `OBSIDIAN_VAULT`.
The original import ZIP, selections, logs, `.env` files, Terraform state/plans,
and local validation backups are ignored by Git. Review hand-made archives too:
Git ignore rules do not filter them.

## Optional Azure Functions debugging

`azfunc.nvim` is not enabled. The supplied task summary leaves .NET isolated
Azure Functions debugging optional; it needs a suitable .NET adapter and tools
such as Azure Functions Core Tools, a .NET SDK, and netcoredbg. Python DAP remains
configured. No additional Azure Functions plugin was added during this cleanup.
