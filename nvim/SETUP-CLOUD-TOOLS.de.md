# Windows-Einrichtung für Cloud-, KI- und Bildwerkzeuge

**Sprachen:** [English](SETUP-CLOUD-TOOLS.md) | [Français](SETUP-CLOUD-TOOLS.fr.md) | Deutsch | [日本語](SETUP-CLOUD-TOOLS.ja.md)

Diese Anleitung installiert die optionalen Cloud-, KI- und Bildwerkzeuge der Konfiguration. Beginne mit dem [Installations-README](../README.de.md), danach findest du alltägliche Befehle und Kürzel im [Windows-Handbuch](../MANUAL.de.md).

<a id="before-first-launch"></a>

## Vor dem ersten Start

Installiere die grundlegenden Werkzeuge aus dem README. Öffne nach der Installation von Befehlszeilenwerkzeugen ein neues PowerShell- oder WezTerm-Fenster, damit Neovim den aktualisierten `PATH` erhält. Öffne eine Quelldatei für die Sprachserverinstallation. Warte auf die Downloads, starte Neovim neu und prüfe `:Lazy`, `:Mason`, `:checkhealth` und `:ConformInfo`.

Zusätzliche Mason-Pakete lassen sich auch manuell installieren:

```vim
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
Tree-sitter installiert zusätzlich zu den vorhandenen Sprachparsern `bicep`, `csv`, `hcl`, `terraform` und `tsv`. Nach der Werkzeuginstallation durch Mason versucht Neovim die Parserinstallation erneut. Ein funktionierender C-Compiler und Tree-sitter CLI sind erforderlich.

<a id="bicep-language-server"></a>

## Bicep-Sprachserver

Installiere das vom Bicep-Sprachserverpaket benötigte .NET SDK und dann Microsofts globales Werkzeug:

```powershell
dotnet --info
dotnet tool install --global Azure.Bicep.LangServer
Get-Command bicep-ls
```
Die Befehle folgen den [offiziellen Bicep-Sprachserveranweisungen](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#bicep-language-server-net-tool). Neovim findet den installierten Befehl `bicep-ls` über `PATH`. Starte Neovim nach der Installation neu. Eine bestehende Installation aktualisierst du mit `dotnet tool update --global Azure.Bicep.LangServer`.

Öffne eine `.bicep`- oder `.bicepparam`-Datei und verwende normale LSP-Kürzel: `K`, `gd`, `gr`, F2, Space c a und Space c d. Bicep CLI zu installieren oder nur `az bicep` auszuführen installiert diesen Sprachserver nicht.

<a id="terraform-yaml-azure-pipelines-and-bash"></a>

## Terraform, YAML, Azure Pipelines und Bash

- **Terraform:** Mason installiert terraform-ls. Installiere Terraform CLI separat nach [HashiCorps Anleitung](https://developer.hashicorp.com/terraform/install). Prüfe `terraform version`. `.tf`- und `.tfvars`-Dateien erhalten Vervollständigung und Diagnosen; Space c f formatiert mit `terraform fmt`.
- **YAML:** Mason installiert yaml-language-server; Space c f verwendet Prettier.
- **Azure Pipelines:** Mason installiert Microsofts [Azure-Pipelines-Sprachserver](https://github.com/microsoft/azure-pipelines-language-server). Er wird bei Arbeitsbereichen mit `azure-pipelines.yml` oder `azure-pipelines.yaml` aktiviert und nutzt das Microsoft-Pipelineschema. Node.js/npm sind erforderlich.
- **Bash:** Mason installiert bash-language-server und shfmt. Space c f formatiert Shell-Dateien. Installiere zum Ausführen von Skripten separat eine Bash-Umgebung.

Die vollständige Sprachtabelle und Tastenbelegungen stehen im [Handbuch](../MANUAL.de.md#language-support-and-formatting).

<a id="azure-cli"></a>

## Azure CLI

Installiere Azure CLI mit Windows Package Manager:

```powershell
winget install --exact --id Microsoft.AzureCLI
```
Starte WezTerm neu und prüfe `az version`. Der Befehl folgt [Microsofts Windows-Installationsanleitung](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows).

| Befehl | Tasten | Ausführung |
| --- | --- | --- |
| `:AzureTerminal` | Space z t | Terminal an der Projektwurzel |
| `:AzureLogin` | Space z l | `az login` |
| `:AzureAccount` | Space z a | `az account show -o table` |
| `:AzureGroups` | Space z g | `az group list -o table` |
| `:AzureResources` | Space z r | `az resource list -o table` |

Die Befehle öffnen ein Snacks-Terminal an der Projektwurzel. Melde dich mit `:AzureLogin` an und prüfe deine Azure-Umgebung mit den Konto-, Gruppen- und Ressourcenbefehlen.

<a id="azure-powershell"></a>

## Azure PowerShell

Nutze PowerShell 7. Installiere das Modul für dein aktuelles Konto nach [Microsofts Az-Installationsanleitung](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell):

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
Get-Module -ListAvailable -Name Az
```
`:AzurePowerShell` oder Space z p öffnet PowerShell 7 und importiert Az. Fehlt das Modul, wird der Installationsbefehl angezeigt. Melde dich an und prüfe deinen Kontext:

```powershell
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
```
Die Konfiguration findet PowerShell über `PATH` und `ProgramFiles`. Die PowerShell-Sprachunterstützung verwendet die von Mason installierten Editor Services.

<a id="codex-and-claude-workspaces"></a>

## Codex- und Claude-Arbeitsbereiche

Installiere die CLIs und melde dich anhand der [offiziellen Codex-CLI-Dokumentation](https://learn.chatgpt.com/docs/codex/cli) und der [Claude-Code-Einrichtungsanleitung](https://code.claude.com/docs/en/setup) an. Prüfe vor dem Neovim-Start `codex --version` und `claude --version`.

`:Codex 1` bis `:Codex 8` und `:Claude 1` bis `:Claude 8` erstellen Neovim-Tabs ausschließlich mit Terminalsitzungen. Der ursprüngliche Codetab bleibt offen. Wechsle mit `gt` und `gT` und drücke zweimal Esc, um die Terminaleingabe zu verlassen. `:CodexEnd` / `:ClaudeEnd` schließen die entsprechenden Arbeitsbereichstabs.

Interaktive Aliase wie `:Codex_8`, `:Claude_8`, `:Codex_End` und `:Claude_End` werden unterstützt. Verwende in Skripten gültige Befehle ohne Unterstriche. Anordnung und Navigation erklärt das [Handbuch](../MANUAL.de.md#ai-session-workspaces).

<a id="csv-and-tsv"></a>

## CSV und TSV

csvview.nvim aktiviert beim Öffnen einer CSV/TSV-Datei eine ausgerichtete Tabellenansicht. Space c v schaltet sie um; `:CsvViewInfo` zeigt Trennzeichen und Kopfzeile. Tab und Shift+Tab behalten ihre Funktion. Siehe [Handbuch](../MANUAL.de.md#csv-and-tsv-tables) und [Plugindokumentation](https://github.com/hat0uma/csvview.nvim).

<a id="images-and-pdf-files"></a>

## Bilder und PDF-Dateien

Bilder und PDFs öffnen in eigenen WezTerm-Tabs über **`wezterm imgcat`**. PNG, JPG/JPEG und GIF öffnen direkt. WebP, AVIF, SVG, BMP, TIFF und PDF benötigen [ImageMagick für Windows](https://imagemagick.org/script/download.php#windows). Prüfe mit `magick -version`. PDF-Vorschauen zeigen die erste Seite und benötigen gegebenenfalls Ghostscript sowie eine ImageMagick-Richtlinie, die PDF-Lesen erlaubt.

Starte Neovim in WezTerm mit `wezterm.exe` in `PATH`. Ein unterstütztes Bild oder PDF im Explorer zu öffnen zeigt eine Vorschau und führt zum Code zurück. Auch `:ImagePreview path/to/image.jpg`, `:ImagePreviewClose` und `:ImagePreviewCloseAll` sind verfügbar. Frühere Vorschauen bleiben bis zum Schließen offen. Beim Beenden räumt Neovim Vorschautabs und temporäre Dateien auf. Siehe [Handbuch](../MANUAL.de.md#image-and-pdf-previews) und [WezTerm-imgcat-Referenz](https://wezterm.org/cli/imgcat.html).

<a id="wallpapers-and-local-settings"></a>

## Hintergrundbilder und lokale Einstellungen

Die Hintergrundauswahl durchsucht Bildordner und Unterordner und speichert einen relativen Pfad. Neovim und WezTerm verwenden beide `NVIM_BACKGROUND_DIR`, sofern gesetzt. Abbrechen erhält die Auswahl; bei fehlendem Bild kehrt das normale Terminalaussehen zurück. Eigene Ordner beschreibt das [Handbuch](../MANUAL.de.md#wezterm-and-wallpapers); Bildquellen stehen in den [Hintergrundbildnachweisen](backgrounds/CREDITS.de.md).

Private Pfade gehören in lokale Umgebungsvariablen wie `OBSIDIAN_VAULT`. Git ignoriert Hintergrundauswahlen, Protokolle, `.env`-Dateien, Terraform-Zustands- und Plandateien sowie lokale Validierungssicherungen. Prüfe manuell erstellte Archive vor dem Weitergeben, da Git-Ignorierregeln deren Inhalt nicht filtern.

<a id="optional-azure-functions-debugging"></a>

## Optionales Azure-Functions-Debugging

Der enthaltene Debugger unterstützt Python. Für .NET-Isolated-Azure-Functions richte einen geeigneten .NET-Adapter ein und installiere nötige Werkzeuge wie Azure Functions Core Tools, ein .NET SDK und netcoredbg. `azfunc.nvim` ist ein optionales Plugin für diesen Ablauf.
