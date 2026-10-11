# Windows-Benutzerhandbuch

**Sprachen:** [English](MANUAL.md) | [Français](MANUAL.fr.md) | Deutsch | [日本語](MANUAL.ja.md)

**Diese Neovim- und WezTerm-Konfiguration ist für Windows bestimmt.** Das Handbuch behandelt Installation, alltägliche Tastenkürzel, optionale Werkzeuge und Anpassungen. Die Beispiele verwenden PowerShell und ermitteln Pfade für den aktuellen Benutzer.

<a id="contents"></a>

## Inhalt

- [Installation und erster Start](#installation-and-first-launch)
- [Bearbeiten und Tastenkürzel](#editing-and-shortcuts)
- [Dateisuche und Explorer](#finding-files-and-using-the-explorer)
- [Sprachunterstützung und Formatierung](#language-support-and-formatting)
- [Python-Debugging](#python-debugging)
- [Git und Projektterminals](#git-and-project-terminals)
- [Arbeitsbereiche für KI-Sitzungen](#ai-session-workspaces)
- [Azure und Cloud-Werkzeuge](#azure-and-cloud-tools)
- [CSV- und TSV-Tabellen](#csv-and-tsv-tables)
- [Bild- und PDF-Vorschauen](#image-and-pdf-previews)
- [Markdown und Obsidian](#markdown-and-obsidian)
- [WezTerm und Hintergrundbilder](#wezterm-and-wallpapers)
- [Anpassungen und Datenschutz](#customization-and-privacy)
- [Pluginverwaltung](#plugin-management)
- [Fehlerbehebung](#troubleshooting)
- [Konfiguration prüfen](#validate-the-configuration)

<a id="installation-and-first-launch"></a>

## Installation und erster Start

Folge den [Installationsschritten im README](README.de.md#install-on-windows). Der Kopierbefehl legt Dateien direkt im Neovim-Konfigurationsverzeichnis ab. Prüfe, dass darin kein zusätzlicher `nvim`-Ordner entstanden ist. Der erste Start benötigt Internet, um Plugins und Sprachwerkzeuge herunterzuladen.

Öffne nach der Installation von Befehlszeilenwerkzeugen ein neues PowerShell-Fenster, damit der aktualisierte `PATH` übernommen wird. Prüfe die grundlegenden Werkzeuge:

```powershell
nvim --version
git --version
fzf --version
rg --version
wezterm --version
```
Die festgelegte Tree-sitter-Version [benötigt](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md) Neovim 0.12 oder neuer, Tree-sitter CLI 0.26.1 oder neuer, `curl`, `tar` und einen C-Compiler. Mason installiert die CLI automatisch; installiere den Compiler separat. Starte WezTerm bei Verwendung von MSVC aus Developer PowerShell, damit Neovim den Compiler und dessen Umgebung findet.

Die Sprachserverinstallation beginnt beim Öffnen einer Quelldatei. Formatierer und debugpy werden kurz nach dem Start installiert. Lass die erste Sitzung offen, bis `:Lazy` und `:Mason` den Abschluss anzeigen, und starte Neovim neu. Nach Abschluss der Mason-Installationen versucht Neovim die Parserinstallation erneut.

Prüfe die Einrichtung mit diesen Befehlen:

```vim
:checkhealth
:Mason
:ConformInfo
:messages
```
<a id="editing-and-shortcuts"></a>

## Bearbeiten und Tastenkürzel

Neovim verwendet den Normalmodus für Navigation und Befehle, den Einfügemodus zum Schreiben und den visuellen Modus für Auswahlen. Mit `i` schreibst du, mit `Esc` kehrst du zum Normalmodus zurück und mit `v` wählst du Text aus. Befehle beginnst du im Normalmodus mit `:`.

Die Leader-Taste ist **Leertaste**, der lokale Leader ist **Backslash**. Bei `Space b c` drückst du die Tasten im Normalmodus nacheinander. Großbuchstaben sind relevant. Drücke die Leertaste und warte, bis Which-Key die verfügbaren Kürzel anzeigt.

| Tasten oder Befehl | Aktion |
| --- | --- |
| Ctrl+S | Im Normal- oder Einfügemodus speichern |
| `:w` / `:q` / `:wq` | Speichern / Fenster schließen / speichern und schließen |
| Esc | Suchhervorhebung im Normalmodus löschen |
| `/text`, dann `n` / `N` | Suchen, nächster / vorheriger Treffer |
| `u` / Ctrl+R | Rückgängig / wiederholen |
| Ctrl+H / J / K / L | Linke / untere / obere / rechte Teilansicht fokussieren |
| Space s v / Space s h | Vertikale / horizontale Teilansicht erstellen |
| Space s c | Aktuelle Teilansicht schließen |
| Ctrl+Tab / Ctrl+Shift+Tab | Nächster / vorheriger Buffer, über WezTerm weitergeleitet |
| Space b n / Space b p | Nächster / vorheriger Buffer mit Leader-Tasten |
| Space b P | Buffer anhand seiner angezeigten Kennzeichnung auswählen |
| Space b c | Aktuellen Buffer schließen |
| Space b o | Andere Buffer schließen; ungespeicherte bleiben erhalten |
| Space b l / Space b r | Buffer links / rechts schließen |
| Space u u | Baum des Änderungsverlaufs umschalten |
| Space u z | Zen-Modus umschalten |
| Space u n | Benachrichtigungsverlauf anzeigen |

Die oberen Tabs zeigen **Buffer**, meist offene Dateien. WezTerm hat eigene Terminaltabs. Speichere geänderte Dateien vor dem Schließen, um Rückfragen oder ein verweigertes Schließen zu vermeiden.

Die Vervollständigung verwendet Blinks [Super-Tab-Voreinstellung](https://cmp.saghen.dev/configuration/keymap). Tab übernimmt einen Vorschlag oder geht im Snippet weiter; Shift+Tab geht darin zurück. Ctrl+Space öffnet die Vervollständigung, Ctrl+N/P wählt Vorschläge aus und Ctrl+E schließt das Menü. Dokumentation öffnet sich nach kurzer Verzögerung automatisch. Automatische Klammerpaare und das Bearbeiten umschließender Zeichen sind ebenfalls aktiviert.

<a id="finding-files-and-using-the-explorer"></a>

## Dateisuche und Explorer

| Tasten | Aktion |
| --- | --- |
| Ctrl+P / Space f f | Datei suchen |
| Ctrl+Shift+F / Space f g | Projekttext durchsuchen |
| Space f b | Offenen Buffer auswählen |
| Space f r | Kürzlich geöffnete Datei auswählen |
| Space f s / Space f S | Dokument- / Arbeitsbereichssymbole des Sprachservers |
| Space f t | TODO-Kommentare suchen |
| `]t` / `[t` | Nächster / vorheriger TODO-Kommentar |
| Ctrl+B | Dateiexplorer öffnen oder schließen |

Im Explorer öffnet Enter einen Eintrag, `v` oder Ctrl+V eine vertikale und `s` oder Ctrl+S eine horizontale Teilansicht. Ctrl+B schließt den Explorer. Ctrl+S hat somit zwei Funktionen: im Explorer eine Teilansicht öffnen und im Editor eine Datei speichern.

Der Explorer folgt der aktiven Datei und zeigt versteckte sowie von Git ignorierte Dateien. Die Dateiauswahl durchsucht das aktuelle Arbeitsverzeichnis. Starte Neovim im Projektordner oder wechsle mit `:cd`. Textsuche unter Windows benötigt ripgrep; siehe [Windows-Hinweise zu fzf-lua](https://github.com/ibhagwan/fzf-lua/blob/main/README-Win.md).

<a id="language-support-and-formatting"></a>

## Sprachunterstützung und Formatierung

Mason installiert Werkzeuge im Neovim-Datenverzeichnis. Unterstützte Sprachen und Werkzeuge:

| Sprache oder Funktion | Werkzeuge | Voraussetzungen außerhalb Neovims |
| --- | --- | --- |
| Python | BasedPyright, Ruff, debugpy | Python; Node.js/npm für BasedPyright |
| PowerShell | PowerShell Editor Services | PowerShell, vorzugsweise Version 7 |
| Java | jdtls | JDK 21+ für den Server, Python 3.9+ für dessen Starter |
| Lua | Lua-Sprachserver, StyLua | Von Mason verwaltete Binärdateien |
| JSON- / YAML-Formatierung | Prettier | Node.js/npm |
| YAML / Azure Pipelines | yamlls, azure_pipelines_ls | Node.js/npm |
| Bash / Shellskripte | bashls, shfmt | Node.js/npm für den Server; Bash zum Ausführen |
| Terraform / HCL | terraformls, terraform_fmt | Terraform CLI zum Formatieren und Prüfen |
| Azure Bicep / Parameter | bicep-ls | .NET SDK und separat installierter Bicep-Sprachserver |
| CSV / TSV | csvview.nvim und Syntaxparser | Kein externer Server nötig |
| Syntaxhervorhebung | Tree-sitter-Parser | Tree-sitter CLI, curl, tar, C-Compiler |

Die Java-Serveranforderungen stehen unter [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration). Dein Projekt kann eine andere Java-Version verwenden. Maven- und Gradle-Projekte werden umfassender unterstützt als einzelne Java-Dateien.

Öffne `:Mason`, um den Installationsfortschritt zu prüfen. Die eingerichteten Werkzeuge kannst du auch manuell installieren:

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
Starte Neovim nach der Sprachserverinstallation neu. PowerShell Editor Services benötigt ein PowerShell-Programm und das Dienstskript von Mason. Bei fehlendem jdtls erscheint eine Java-Benachrichtigung.

| Tasten | Sprachserveraktion |
| --- | --- |
| `gd` / `gD` | Definition / Deklaration |
| `gi` / `gr` | Implementierung / Referenzen |
| `K` | Dokumentation beim Überfahren |
| F2 | Symbol umbenennen |
| Space c a | Codeaktionen im normalen oder visuellen Modus |
| Space c d | Diagnosen für die aktuelle Zeile |
| `]d` / `[d` | Nächste / vorherige Diagnose |
| Space x x | Projektdiagnosen umschalten |
| Space x X | Diagnosen des aktuellen Buffers umschalten |
| Space x s | Symbolansicht umschalten |

Diese Kürzel sind verfügbar, wenn ein Sprachserver an die Datei angebunden ist. Prüfe Server mit `:checkhealth vim.lsp` und Startfehler mit `:messages`.

Formatierung erfolgt **manuell** mit Space c f. Python nutzt Ruff, Lua StyLua, JSON/YAML Prettier, Bash shfmt und Terraform `terraform fmt`. Andere Sprachen verwenden bei Verfügbarkeit den Formatierer des angebundenen Sprachservers. Beim Speichern wird nicht automatisch formatiert. `:ConformInfo` zeigt den verfügbaren Formatierer der aktuellen Datei.

Für Java organisiert Space j o Imports, Space j v extrahiert eine Variable und Space j c eine Konstante. Jedes Java-Projekt hat einen eigenen Arbeitsbereichscache, auch bei gleichnamigen Projektordnern. Bei einem neuen Cache muss jdtls das Projekt gegebenenfalls zunächst indizieren.

<a id="python-debugging"></a>

## Python-Debugging

Öffne eine Python-Datei und prüfe, dass debugpy in Mason vollständig installiert ist. Der Adapter verwendet Masons debugpy-Interpreter. Aktiviere für den Anwendungsinterpreter die virtuelle Projektumgebung vor dem Neovim-Start oder setze bei Bedarf `require("dap-python").resolve_python` in deiner lokalen Konfiguration.

| Tasten | Aktion |
| --- | --- |
| F9 | Haltepunkt umschalten |
| F5 | Debugging starten / fortsetzen |
| F10 | Funktion überspringen |
| F11 / Shift+F11 | In Funktion hinein / aus Funktion heraus |
| Space d r | Debug-REPL öffnen |
| Space d t | Sitzung beenden |

Die Debugoberfläche lädt mit dem Debugger, öffnet sich beim Start oder Anhängen und schließt am Sitzungsende. Wähle bei Nachfrage eine Python-Startkonfiguration. Diese Einrichtung unterstützt Python-Debugging. Java-Debugging benötigt einen zusätzlichen Adapter und weitere Einstellungen.

<a id="git-and-project-terminals"></a>

## Git und Projektterminals

| Tasten | Aktion |
| --- | --- |
| Space g g | Neogit-Status öffnen |
| Space g c | Commitoberfläche öffnen |
| Space g p / Space g P | Push / Pull |
| Space g l | Git-Verlauf anzeigen |
| Space g d | Diffansicht öffnen |
| Space g H | Verlauf der aktuellen Datei anzeigen |
| `]h` / `[h` | Nächster / vorheriger geänderter Abschnitt |
| Space g h | Abschnittsvorschau |
| Space g s / Space g r | Aktuellen Abschnitt vormerken / zurücksetzen |
| Space g b | Autor der aktuellen Zeile anzeigen |
| Space t t | Terminal an der Projektwurzel umschalten |
| Esc, Esc | Terminaleingabemodus verlassen |

Das Zurücksetzen eines Abschnitts verwirft dessen Änderungen. Push und Pull nutzen deine vorhandenen Git-Zugangsdaten und Remotekonfiguration. Diese Neovim-Konfiguration setzt keinen Git-Autornamen und keine E-Mail-Adresse.

Das Terminal startet an der Projektwurzel. Diese wird anhand von Git, Python-Projektdateien, Java-Builddateien, PowerShell-Analyseeinstellungen oder Obsidian-Vault-Markierungen erkannt. Ohne erkannte Wurzel wird das aktuelle Arbeitsverzeichnis verwendet.

Space a c startet Codex, Space a C startet Claude Code. Installiere die CLIs, melde dich an und prüfe ihre Verfügbarkeit in `PATH`, bevor du diese Kürzel nutzt.

<a id="ai-session-workspaces"></a>

## Arbeitsbereiche für KI-Sitzungen

Installiere die externe [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) und/oder [Claude Code](https://code.claude.com/docs/en/setup) und melde dich nach deren Anleitung an. Prüfe `codex --version` und `claude --version` im Terminal, aus dem du Neovim startest. Space a c und Space a C öffnen jeweils ein einzelnes Terminal. Die folgenden Befehle erstellen eine eigene **Neovim-Tabseite** mit einer oder mehreren Sitzungen:

| Befehl | Aktion |
| --- | --- |
| `:Codex` / `:Claude` | Eine CLI-Sitzung öffnen |
| `:Codex 8` / `:Claude 8` | Acht unabhängige Sitzungen öffnen |
| `:Codex1` bis `:Codex8` | Angegebene Anzahl Codex-Sitzungen öffnen |
| `:Claude1` bis `:Claude8` | Angegebene Anzahl Claude-Sitzungen öffnen |
| `:CodexEnd` / `:ClaudeEnd` | Alle Codex- / Claude-Arbeitsbereichstabs schließen |

Die Anzahl muss eine ganze Zahl von 1 bis 8 sein. `:Codex_8`, `:Claude_8`, `:Codex_End` und `:Claude_End` sind interaktive Befehlszeilenabkürzungen. Verwende in Skripten und Tastenbelegungen die Formen ohne Unterstriche.

Dein Code bleibt im ursprünglichen Tab. Im KI-Tab versteckt Bufferline die Dateitabs, damit die Sitzungen im Mittelpunkt stehen. Eine Sitzung füllt den Tab, zwei werden vertikal gestapelt, drei bis acht in zwei Spalten angeordnet. Jede Sitzung startet an der aktuellen Projektwurzel. Vergrößere das Terminal bei vielen Sitzungen.

Mit `gt` und `gT` wechselst du Neovim-Tabs. Im Normalmodus wechselt Ctrl+H/J/K/L zwischen Teilansichten; `i` aktiviert die Terminaleingabe. Zweimal Esc führt zurück zum Normalmodus.

`:CodexEnd` schließt alle Codex-Arbeitsbereichstabs; `:ClaudeEnd` alle Claude-Arbeitsbereichstabs. Beide kehren zum ursprünglichen Codetab zurück, sofern er noch offen ist. Das Schließen einer Sitzung beendet ihren Prozess. Anmeldung, Berechtigungen und Kontonutzung verwalten die CLIs.

<a id="azure-and-cloud-tools"></a>

## Azure und Cloud-Werkzeuge

Folge der [Windows-Cloud-Einrichtungsanleitung](nvim/SETUP-CLOUD-TOOLS.de.md), um optional Azure CLI, PowerShell Az, Terraform CLI und den Bicep-Sprachserver zu installieren. Mason verwaltet die eingerichteten Bash-, YAML-, Terraform- und Azure-Pipelines-Server.

| Tasten | Befehl | Aktion |
| --- | --- | --- |
| Space z t | `:AzureTerminal` | Projektterminal öffnen |
| Space z l | `:AzureLogin` | `az login` ausführen |
| Space z a | `:AzureAccount` | Aktives Azure-Konto anzeigen |
| Space z g | `:AzureGroups` | Ressourcengruppen auflisten |
| Space z r | `:AzureResources` | Ressourcen auflisten |
| Space z p | `:AzurePowerShell` | PowerShell 7 öffnen und vorhandenes Az importieren |

Konto- und Ressourcenbefehle verwenden deine aktuelle Azure-Anmeldung. Fehlt Az, zeigt `:AzurePowerShell` den Installationsbefehl. Melde dich mit `Connect-AzAccount` in diesem Terminal bei Azure PowerShell an.

Bicep verwendet normale LSP-Kürzel für Diagnosen, Vervollständigung, Dokumentation, Definitionen, Referenzen, Umbenennen und Codeaktionen. Starte Neovim nach der Installation von `bicep-ls` neu. `.bicepparam` verwendet den Bicep-Parameterdateityp. Bicep CLI (`bicep` oder `az bicep`) und Sprachserver (`bicep-ls`) sind separate Werkzeuge.

Azure Pipelines LSP benötigt einen Arbeitsbereich mit `azure-pipelines.yml` oder `azure-pipelines.yaml`. Microsoft-Schemapatterns erfassen auch Vorlagen in `Azure-Pipelines/` und `Pipelines/`. Allgemeines YAML verwendet yamlls. Terraform-Dateien `.tf` und `.tfvars` verwenden terraform-ls; Formatierung benötigt Terraform CLI. Bash-Unterstützung gilt für als `sh` oder `bash` erkannte Shell-Dateien.

Die Projekterkennung berücksichtigt auch `bicepconfig.json`, Pipelinedateien, `.terraform` und `main.tf`. Azure-Functions-Debugging ist eine optionale Erweiterung und benötigt einen .NET-Debugadapter sowie die passenden Werkzeuge.

<a id="csv-and-tsv-tables"></a>

## CSV- und TSV-Tabellen

Beim Öffnen von `.csv` oder `.tsv` aktiviert csvview.nvim eine ausgerichtete Tabellenansicht mit Rahmen und automatisch erkannter fester Kopfzeile. CSV verwendet Kommas, TSV Tabulatoren. Zeilen mit `#` oder `//` am Anfang gelten als Kommentare.

Space c v / `:CsvViewToggle` schaltet die Anzeige um. Mit `:CsvViewEnable`, `:CsvViewDisable` und `:CsvViewInfo` aktivierst, deaktivierst oder prüfst du sie. Beispiel:

```vim
:CsvViewEnable delimiter=; header_lnum=1
```
Während der Tabellenansicht kannst du normal weiterarbeiten. Tab und Shift+Tab behalten ihre gewohnte Funktion.

<a id="image-and-pdf-previews"></a>

## Bild- und PDF-Vorschauen

Öffne eine unterstützte Datei im Explorer, verwende `:edit` oder `:ImagePreview path/to/image.jpg`. Ohne Argument verwendet `:ImagePreview` die aktuelle Datei. Nutze Dateinamenvervollständigung bei Pfaden mit Leerzeichen; der Befehl akzeptiert den vollständigen Pfad ohne Shell-Anführungszeichen.

Jede Vorschau öffnet einen eigenen **WezTerm-Tab**, benannt nach der Datei. Frühere Vorschauen bleiben offen. Neovim kehrt zum vorherigen Codebuffer zurück, anstatt Bild oder PDF als Binärtext anzuzeigen.

| Format | Anzeige |
| --- | --- |
| PNG, JPG/JPEG, GIF | Direkt mit `wezterm imgcat` |
| WebP, AVIF, SVG, BMP, TIF/TIFF | ImageMagick konvertiert in ein temporäres PNG |
| PDF | ImageMagick konvertiert Seite 1 in ein temporäres PNG |

Neovim muss in WezTerm laufen, mit `wezterm.exe` in `PATH` und vom Terminal geerbtem `WEZTERM_PANE`. Weitere Formate benötigen [ImageMagick](https://imagemagick.org/script/download.php#windows). Für PDF-Dateien können Ghostscript und eine lokale ImageMagick-Richtlinie nötig sein, die PDF-Konvertierung erlaubt. Konvertierungsfehler erscheinen als Benachrichtigungen.

`:ImagePreviewClose` schließt die letzte Vorschau; `:ImagePreviewCloseAll` alle Vorschauen dieses Neovim-Prozesses. Mit dem WezTerm-Schließknopf oder Ctrl+Shift+W lässt sich eine direkt schließen. Beim Beenden schließt Neovim seine Vorschaufenster und löscht temporäre Dateien. Der Betrachter läuft über die Windows-Eingabeaufforderung (`cmd.exe`).

<a id="markdown-and-obsidian"></a>

## Markdown und Obsidian

Die Markdown-Darstellung lädt beim Öffnen einer Markdown-Datei. Space m r schaltet sie um. Codeblöcke und Überschriften behalten transparente Hintergründe, damit das WezTerm-Hintergrundbild sichtbar bleibt.

Obsidian ist optional und lädt über `:Obsidian` oder seine Kürzel. Der Vault-Pfad wird in dieser Reihenfolge gewählt:

1. `vim.g.nvim_obsidian_vault`, vor dem Laden des Plugins gesetzt.
2. Die Umgebungsvariable `OBSIDIAN_VAULT`.
3. `~/Documents/Obsidian`, für den aktuellen Benutzer aufgelöst.

Gib vor dem Neovim-Start in PowerShell einen vorhandenen Vault an:

```powershell
$env:OBSIDIAN_VAULT = Join-Path $HOME 'Documents\Obsidian'
nvim
```
Für eine dauerhafte lokale Einstellung verwende Windows-Benutzerumgebungsvariablen oder:

```powershell
[Environment]::SetEnvironmentVariable('OBSIDIAN_VAULT', (Join-Path $HOME 'Documents\Obsidian'), 'User')
```
Starte WezTerm nach dauerhaften Umgebungsänderungen neu. Diese Einstellungen gehören zur lokalen Maschine und müssen nicht in geteilte Lua-Dateien aufgenommen werden.

| Tasten | Aktion |
| --- | --- |
| Space o q | Schnell zwischen Notizen wechseln |
| Space o s | Vault durchsuchen |
| Space o n | Notiz erstellen |
| Space o t | Heutige Tagesnotiz öffnen |
| Space o b | Rückverweise anzeigen |
| Space o c | Vault und Plugineinrichtung prüfen |

Führe einmal `:Obsidian` aus, um die Integration zu laden, und öffne eine Notiz im eingerichteten Vault. Notiz- und Tagvervollständigung verwendet den eingebauten Sprachserver des Plugins mit Blink. Markdown-Darstellung funktioniert auch außerhalb des Vaults.

<a id="wezterm-and-wallpapers"></a>

## WezTerm und Hintergrundbilder

Die Quellen der enthaltenen Hintergrundbilder stehen in den [Bildnachweisen](nvim/backgrounds/CREDITS.de.md). Bilder aus [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) wurden entfernt, weil die Hintergrundsammlung ersetzt wurde.

Installiere die ergänzende Konfiguration unter `$HOME\.wezterm.lua`. WezTerm verwendet Tokyo-Night-Farben und zeigt bei aktivem Neovim ein abgedunkeltes Hintergrundbild. Beim Beenden Neovims oder fehlendem Bild wird das normale Terminalaussehen wiederhergestellt. Das Terminalfenster bleibt undurchsichtig.

| Tasten oder Befehl | Aktion |
| --- | --- |
| Space u b / `:BackgroundPick` | Bild auswählen |
| Space u B / `:BackgroundFolder` | Bildordner im Windows-Explorer öffnen |
| Ctrl+Tab / Ctrl+Shift+Tab | Bei aktivem Neovim Buffer wechseln, sonst Terminaltabs |
| Alt+Enter | WezTerm-Vollbild umschalten |
| Ctrl+Shift+L | WezTerm-Debuganzeige öffnen |

Die Auswahl durchsucht den Bildordner und Unterordner nach PNG, JPG/JPEG, GIF, BMP und WebP. Sie nutzt fzf-lua, falls verfügbar, sonst Neovims eingebaute Auswahl. SVG-Dateien werden nicht gelistet.

Der Standardordner ist Neovims Konfigurationsverzeichnis plus `backgrounds`, normalerweise `$env:LOCALAPPDATA\nvim\backgrounds`. Die Auswahl wird als relativer Pfad wie `Magi/01-Magi-Star.jpg` in `selected-background.txt` gespeichert. Abbrechen erhält die Auswahl. WezTerm prüft sie etwa einmal pro Sekunde. Alte absolute Auswahlpfade funktionieren lokal weiterhin; die nächste Bildauswahl speichert einen relativen Pfad.

Für einen eigenen Ordner setze vor dem Start beider Anwendungen dieselbe Umgebungsvariable:

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```
Lege Bilder dort ab, starte WezTerm neu und wähle eines in Neovim. Verwende einen absoluten Ordner oder einen relativ zum Benutzerordner angegebenen Pfad `~/...`. Beide Anwendungen müssen denselben Wert erhalten. WezTerm berücksichtigt auch `XDG_CONFIG_HOME` und `NVIM_APPNAME`, falls du diese Neovim-Einstellungen verwendest.

<a id="customization-and-privacy"></a>

## Anpassungen und Datenschutz

Neovim ermittelt Konfigurations-, Daten- und Cachepfade über `stdpath()`. Die tatsächlichen Orte zeigst du im Editor an:

```vim
:lua print(vim.fn.stdpath("config"))
:lua print(vim.fn.stdpath("data"))
:lua print(vim.fn.stdpath("cache"))
```
Verwende `vim.fn.expand("~/...")`, `vim.fs.joinpath()` und Umgebungsvariablen für neue lokale Pfade. PowerShell wird über `PATH`, `ProgramFiles` und `SystemRoot` gefunden; ein festes Laufwerk oder ein Benutzername ist nicht erforderlich.

Die Haupteinstellungen stehen in `nvim/lua/config/options.lua`, Editorkürzel in `nvim/lua/config/keymaps.lua` und Plugineinstellungen in `nvim/lua/plugins/`. WezTerm-Aussehen, Hintergrundhelligkeit und Terminalkürzel stehen in `WezTerminal-Config/.wezterm.lua`. Wähle in WezTerm eine lokal installierte Nerd Font, um alle Symbole anzuzeigen.

Eine Hintergrundauswahl erstellt eine lokale Datei mit relativem Bildpfad. Git ignoriert Auswahlen, Protokolle, Sitzungen, temporäre Editordateien und lokale Validierungssicherungen. Auch `.env`, `.terraform/`, Terraform-Zustands- und Plandateien sowie Absturzprotokolle werden ignoriert. Private Vault-Pfade und Zugangsdaten gehören in lokale Einstellungen.

Ignorierregeln gelten für nicht verfolgte Dateien. Sie entfernen keine bereits von Git verfolgten Dateien und filtern keine manuell erstellten ZIP-Archive. Prüfe freigegebene Dateien, besonders Archive und Sicherungen mit möglichen alten privaten Pfaden.

Dateinamen, Projektnamen, zuletzt verwendete Dateien und Bufferpfade sind im Editor sichtbar. Beachte das bei Screenshots und Bildschirmfreigaben.

Git legt den Autornamen und die E-Mail-Adresse von Commits fest. Prüfe die Identitäten im Repositoryverlauf mit:

```powershell
git log --all --format='%h %an <%ae>'
```
Für einen öffentlichen Alias und eine GitHub-noreply-Adresse bei zukünftigen Commits setze diese Werte für das Repository. Ersetze beide Platzhalter durch deine eigenen Angaben:

```powershell
git config user.name 'YOUR_PUBLIC_ALIAS'
git config user.email 'YOUR_GITHUB_NOREPLY_EMAIL'
```
Kopiere deine tatsächliche noreply-Adresse aus den GitHub-E-Mail-Einstellungen; siehe [GitHubs Anleitung zur Commit-E-Mail-Adresse](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address). Diese Einstellungen betreffen zukünftige Commits. Bestehende behalten ursprüngliche Autoren- und Committerangaben, sofern die Historie nicht umgeschrieben wird.

<a id="plugin-management"></a>

## Pluginverwaltung

Prüfe den Pluginstatus mit `:Lazy`. `:Lazy restore` stellt die in `lazy-lock.json` erfassten Versionen wieder her. `:Lazy update` installiert neuere Versionen und kann die Lockdatei ändern. Behalte sie beim Weitergeben der Konfiguration. Plugins ohne Lockdateieintrag werden bei der ersten Verwendung installiert.

Mit `:Mason` prüfst du Sprachwerkzeuge, mit `:MasonUpdate` aktualisierst du die Registrierung und mit `:MasonInstall` installierst du Pakete. Masons tool-installer fordert außerdem automatisch die eingerichteten Formatierer, debugpy und Tree-sitter CLI an.

Bei verfügbarem Compiler lassen sich Parser ausdrücklich installieren:

```vim
:TSInstall bash bicep csv hcl java json lua markdown markdown_inline powershell python query regex terraform toml tsv vim vimdoc yaml
:TSUpdate
```
`TSInstall` fügt angeforderte Parser hinzu; `TSUpdate` aktualisiert installierte Parser nach einem Pluginupdate. Öffne die Datei erneut, falls die Hervorhebung noch nicht aktiv ist.

<a id="troubleshooting"></a>

## Fehlerbehebung

| Symptom | Prüfen |
| --- | --- |
| Konfiguration wirkt unverändert | `stdpath("config")` ausgeben; verschachteltes `nvim/nvim` und Umgebungsüberschreibungen prüfen. |
| Plugininstallation scheitert | Git, Netzwerk, `:Lazy` und `:messages` prüfen. |
| Dateiauswahl oder Textsuche scheitert | `fzf --version` und `rg --version` im Neovim-Startterminal prüfen. |
| Symbole erscheinen als Kästchen | Nerd Font in WezTerm einstellen. |
| Keine Syntaxhervorhebung | `:checkhealth nvim-treesitter` ausführen, CLI und Compiler prüfen, dann `:TSInstall` und Datei erneut öffnen. |
| Keine Python-Diagnosen | BasedPyright/Ruff in `:Mason` prüfen, nach Installation neu starten und Projektumgebung aktivieren. |
| PowerShell LSP deaktiviert | PowerShell Editor Services installieren, `pwsh`/`powershell.exe` prüfen, Neovim neu starten. |
| Java-Server startet nicht | JDK- und Python-Versionen, jdtls in `:Mason` und nach Pluginladen `:JdtShowLogs` prüfen. |
| Formatierkürzel ohne Wirkung | `:ConformInfo` prüfen, Formatierer installieren und `PATH` kontrollieren. |
| Debugging scheitert | debugpy in `:Mason`, Anwendungsinterpreter und Debug-REPL-Meldungen prüfen. |
| Obsidian findet keinen Arbeitsbereich | `OBSIDIAN_VAULT` auf bestehenden Vault setzen und Neovim neu starten. |
| Hintergrund fehlt | `$HOME\.wezterm.lua`, Bildordner, Auswahldatei und `NVIM_BACKGROUND_DIR` in beiden Prozessen prüfen. |
| Ctrl+Tab wechselt Terminaltabs | Neovim innerhalb WezTerms neu starten, Space b n/p versuchen und ergänzende Konfiguration prüfen. |
| Grafikdarstellung scheitert | `config.front_end = "OpenGL"` in der lokalen WezTerm-Konfiguration versuchen. |
| KI-Sitzungen scheitern | CLI in PATH prüfen, ganze Zahl von 1 bis 8 verwenden und Terminal für viele Teilansichten vergrößern. |
| KI-Unterstrichalias scheitert im Skript | `Codex8`, `Claude8`, `CodexEnd` oder `ClaudeEnd` nutzen; Unterstrichformen sind interaktive Abkürzungen. |
| Bicep LSP fehlt | `bicep-ls` in PATH prüfen und neu starten; Bicep CLI allein genügt nicht. |
| Terraform-Formatierung scheitert | `terraform version` prüfen; Mason installiert den Sprachserver separat. |
| Azure-Kürzel scheitern | `az version`, Anmeldung/Konto und PowerShell 7/Az für `AzurePowerShell` prüfen. |
| Bildvorschau scheitert | Neovim in WezTerm starten, `wezterm` in PATH und `:messages` prüfen. |
| Bild- oder PDF-Konvertierung scheitert | `magick -version` prüfen; PDFs benötigen eventuell Ghostscript und passende Richtlinien. |

Bei fehlenden externen Programmen zeigt Neovim eine Benachrichtigung. Verpasste Meldungen findest du über `:messages` oder Space u n.

<a id="validate-the-configuration"></a>

## Konfiguration prüfen

Führe diese Befehle im Repositoryordner in PowerShell aus. Sie installieren keine Plugins und verändern deine aktive Neovim-Konfiguration nicht:

```powershell
nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
wezterm --config-file '.\WezTerminal-Config\.wezterm.lua' show-keys
```
Der erste Befehl prüft Lua-Syntax, Dokumentationslinks und Tastenkürzel. Er testet außerdem Pfade mit Windows-Beispielprofilen, Hintergrundauswahl, Debuggerladen, Obsidian-Einstellungen, erneute Parserinstallationsversuche, Java-Caches, Cloud-Werkzeuge, KI-Sitzungen und Vorschaubefehle.

Die Prüfungen simulieren Pluginverhalten. Teste interaktive Funktionen auch in deiner normalen Neovim-Sitzung. Der zweite Befehl lädt die WezTerm-Konfiguration und gibt ihre Tastenbelegungen aus.
