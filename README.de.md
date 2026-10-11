# Neovim- und WezTerm-Konfiguration für Windows

**Sprachen:** [English](README.md) | [Français](README.fr.md) | Deutsch | [日本語](README.ja.md)

**Diese Konfiguration ist für Windows bestimmt.** Sie verbindet Neovim, PowerShell und WezTerm zum Bearbeiten von Code, für die Arbeit mit Git und zum Debuggen von Python. Sie enthält einen Dateiexplorer, Vervollständigung, Sprachserver, Markdown-Darstellung und eine optionale Obsidian-Integration.

Weitere Funktionen sind Unterstützung für Azure/Bicep, Terraform, YAML und Bash, das Bearbeiten von CSV/TSV-Tabellen, eigene Codex- und Claude-Sitzungen, Bild- und PDF-Vorschauen sowie Terminalhintergründe.

Quellrepository: [Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config).

Pfade werden automatisch für den aktuellen Windows-Benutzer ermittelt. Du kannst die Konfiguration verwenden, ohne deinen Benutzernamen oder einen festen Laufwerksbuchstaben einzutragen.

Im [Windows-Benutzerhandbuch](MANUAL.de.md) findest du die vollständige Übersicht der Tastenkürzel, die Einrichtung der Sprachunterstützung, Hintergrundbilder, Anpassungen und Fehlerbehebung.

<a id="requirements"></a>

## Voraussetzungen

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 oder neuer**.
- [Git für Windows](https://git-scm.com/downloads/win), [fzf](https://github.com/junegunn/fzf) und [ripgrep](https://github.com/BurntSushi/ripgrep), verfügbar in `PATH`.
- [WezTerm](https://wezterm.org/installation.html) für Terminalhintergründe und die Ctrl+Tab-Integration; Neovim funktioniert auch ohne diese Terminalfunktionen.
- PowerShell 7 ist die bevorzugte Shell. Windows PowerShell wird ebenfalls für Editor Services und die CPU-Statusanzeige unterstützt.
- Für Syntaxparser: Tree-sitter CLI **0.26.1 oder neuer**, `curl`, `tar` und ein C-Compiler in `PATH`, etwa MSVC in einer Developer-PowerShell-Sitzung oder Clang. Dies entspricht den [Anforderungen der festgelegten Tree-sitter-Version](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md).
- Python, Node.js/npm und ein JDK nach Bedarf für die im Handbuch beschriebenen Sprachwerkzeuge. Eine Nerd Font ist optional, um Symbole darzustellen.

<a id="install-on-windows"></a>

## Installation unter Windows

Lade dieses Repository herunter oder klone es in PowerShell:

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```
Schließe Neovim, öffne PowerShell im Repositoryordner und führe die folgenden Befehle aus. Eine vorhandene Konfiguration wird vor dem Kopieren der neuen Dateien in eine Sicherung mit Zeitstempel verschoben. Installierte Plugindaten bleiben erhalten.

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
Neovim verwendet normalerweise `$env:LOCALAPPDATA\nvim`. WezTerm liest `$HOME\.wezterm.lua`. Starte WezTerm neu, führe `nvim` aus und warte auf den Abschluss der ersten Plugin- und Werkzeugdownloads. Öffne eine Quelldatei, um die Sprachserverinstallation auszulösen. Starte Neovim nach der ersten Installation neu und führe `:checkhealth` und `:Mason` aus.

<a id="useful-shortcuts"></a>

## Nützliche Tastenkürzel

Die Leader-Taste ist **Leertaste**. Drücke die aufgeführten Tasten nacheinander; zum Beispiel öffnet `Space f f` die Dateiauswahl. Drücke die Leertaste und warte auf die Which-Key-Hilfe.

| Tasten | Aktion |
| --- | --- |
| Ctrl+S | Aktuelle Datei speichern |
| Ctrl+B | Dateiexplorer ein- oder ausblenden |
| Ctrl+P / Space f f | Datei suchen |
| Space f g | Text im Projekt suchen |
| Ctrl+Tab / Ctrl+Shift+Tab | Nächste / vorherige Datei in WezTerm |
| Space b c | Aktuelle Datei schließen |
| Space c f | Aktuelle Datei formatieren |
| Space g g | Git-Status öffnen |
| Space u b | Terminalhintergrund auswählen |
| Space t t | Projektterminal ein- oder ausblenden |
| Space c v | CSV/TSV-Tabellenansicht umschalten |
| Space z t | Azure-Projektterminal öffnen |

Mit `:Codex 8` oder `:Claude 8` öffnest du acht unabhängige CLI-Sitzungen in einem eigenen Neovim-Tab. Beim Öffnen eines Bildes oder PDFs entsteht ein separater WezTerm-Vorschautab. Installiere die erforderlichen externen Werkzeuge vor der Verwendung dieser Funktionen; siehe [Handbuch](MANUAL.de.md#ai-session-workspaces) und [Cloud-Einrichtungsanleitung](nvim/SETUP-CLOUD-TOOLS.de.md).

<a id="files-and-sharing"></a>

## Dateien und Weitergabe

- `nvim/` enthält die zu installierende Neovim-Konfiguration.
- `WezTerminal-Config/.wezterm.lua` ist die ergänzende Windows-Terminalkonfiguration.
- [MANUAL.md](MANUAL.de.md) erklärt alle eingerichteten Funktionen und lokalen Einstellungen.
- `nvim/lazy-lock.json` hält Pluginrevisionen fest; behalte die Datei beim Weitergeben der Konfiguration.

Hintergrundauswahlen verwenden Pfade relativ zum Bildordner. Git ignoriert die Auswahldatei, Protokolle, temporäre Dateien, lokale Umgebungsdateien sowie Terraform-Zustands- und Plandateien. Persönliche Pfade setzt du über lokale Umgebungsvariablen wie `OBSIDIAN_VAULT` und `NVIM_BACKGROUND_DIR`.

Die Bilder aus [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) wurden entfernt, weil die Hintergrundsammlung ersetzt wurde. Quellen der aktuellen Bilder sind in den [Hintergrundbildnachweisen](nvim/backgrounds/CREDITS.de.md) aufgeführt.

Führe vor dem Weitergeben neuer Änderungen die [Validierungsbefehle](MANUAL.de.md#validate-the-configuration) aus und überprüfe deine persönlichen Anpassungen.
