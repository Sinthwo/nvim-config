# Neovim-Screenshot-Galerie

**Sprachen:** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

Screenshots der Neovim- und WezTerm-Konfiguration für Windows mit Beispieldateien in einer isolierten Vorschau. Die KI-Ansichten zeigen nur das Layout oder die Ersteinrichtung; die Debug-Ansicht zeigt Fenster ohne laufende Sitzung. Cloud-Bereitstellungen und Kontovorgänge werden nicht gezeigt.

[Zurück zur Haupt-README](../../README.de.md)

- [Bearbeiten und Navigieren](#bearbeiten-und-navigieren)
- [Schreiben und Daten](#schreiben-und-daten)
- [Git und Verlauf](#git-und-verlauf)
- [Terminals und Werkzeuge](#terminals-und-werkzeuge)
- [KI-Arbeitsbereiche](#ki-arbeitsbereiche)
- [Japanisches Schreibprofil](#japanisches-schreibprofil)

## Bearbeiten und Navigieren

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Start-Dashboard](dashboard.png)](dashboard.png) | **Start-Dashboard** — Hai-Logo und Tastenkürzel für Dateien, Suche, Plugins und Terminals. | `Space u D` · [Anleitung](../../MANUAL.de.md#dashboard-und-benachrichtigungen) |
| [![Editor und Dateiexplorer](editor-explorer.png)](editor-explorer.png) | **Editor und Dateiexplorer** — Lua-Datei neben dem Projektbaum; offene Dateien stehen oben. | `Ctrl+B` · [Anleitung](../../MANUAL.de.md#dateisuche-und-explorer) |
| [![Dateiauswahl](file-picker.png)](file-picker.png) | **Dateiauswahl** — Dateinamensuche mit Vorschau der ausgewählten Datei. | `Space f f` · [Anleitung](../../MANUAL.de.md#dateisuche-und-explorer) |
| [![Tastenkürzel entdecken](shortcuts.png)](shortcuts.png) | **Tastenkürzel entdecken** — Which-Key gruppiert die verfügbaren Leader-Tastenkürzel nach Aufgabe. | `Space` · [Anleitung](../../MANUAL.de.md#bearbeiten-und-tastenkürzel) |
| [![Textsuche im Projekt](search.png)](search.png) | **Textsuche im Projekt** — Texttreffer im Projekt neben einer Vorschau der ausgewählten Zeile. | `Space f g` · [Anleitung](../../MANUAL.de.md#dateisuche-und-explorer) |
| [![TODO-Suche](todo.png)](todo.png) | **TODO-Suche** — TODO-Treffer mit dem umgebenden Code im Vorschaufenster. | `Space f t` · [Anleitung](../../MANUAL.de.md#dateisuche-und-explorer) |
| [![Temporäre Notizen](scratch.png)](scratch.png) | **Temporäre Notizen** — Ein schwebender Notizpuffer bleibt neben dem aktuellen Code sichtbar. | `Space u .` · [Anleitung](../../MANUAL.de.md#git-und-projektterminals) |
| [![Benachrichtigungsverlauf](notifications.png)](notifications.png) | **Benachrichtigungsverlauf** — Frühere Editormeldungen gesammelt im Benachrichtigungsverlauf. | `Space u n` · [Anleitung](../../MANUAL.de.md#dashboard-und-benachrichtigungen) |
| [![Zen-Modus](zen.png)](zen.png) | **Zen-Modus** — Zentrierter Markdown-Puffer ohne die umgebenden Editorpanels. | `Space u z` · [Anleitung](../../MANUAL.de.md#bearbeiten-und-tastenkürzel) |

## Schreiben und Daten

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Codevervollständigung](completion.png)](completion.png) | **Codevervollständigung** — Lua-Vorschläge mit Dokumentation zum ausgewählten Eintrag. | `Ctrl+Space` · [Anleitung](../../MANUAL.de.md#bearbeiten-und-tastenkürzel) |
| [![Sprachdiagnosen](diagnostics.png)](diagnostics.png) | **Sprachdiagnosen** — Python-Typfehler direkt im Code und im Diagnosefenster. | `Space x x` · [Anleitung](../../MANUAL.de.md#sprachunterstützung-und-formatierung) |
| [![Markdown-Darstellung](markdown.png)](markdown.png) | **Markdown-Darstellung** — Gestaltete Überschriften, Kontrollkästchen, Hinweis, Code und Tabelle. | `Space m r` · [Anleitung](../../MANUAL.de.md#markdown-und-obsidian) |
| [![CSV-Tabellen](csv.png)](csv.png) | **CSV-Tabellen** — CSV-Werte in ausgerichteten Spalten, weiterhin als Text bearbeitbar. | `Space c v` · [Anleitung](../../MANUAL.de.md#csv--und-tsv-tabellen) |
| [![Obsidian-Notizen](obsidian.png)](obsidian.png) | **Obsidian-Notizen** — Schnellauswahl für Beispielnotizen im Vault mit Notizvorschau. | `Space o q` · [Anleitung](../../MANUAL.de.md#markdown-und-obsidian) |
| [![Bildvorschau](image_preview.png)](image_preview.png) | **Bildvorschau** — Ein Bild in einem eigenen WezTerm-Vorschautab. | `:ImagePreview path/to/image.jpg` · [Anleitung](../../MANUAL.de.md#bild--und-pdf-vorschauen) |

## Git und Verlauf

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Git-Status](git.png)](git.png) | **Git-Status** — Neogit zeigt die geänderte Datei und ihre noch nicht vorgemerkten Änderungen. | `Space g g` · [Anleitung](../../MANUAL.de.md#git-und-projektterminals) |
| [![Änderungen nebeneinander](diff.png)](diff.png) | **Änderungen nebeneinander** — Liste geänderter Dateien neben einem Codevergleich in zwei Spalten. | `Space g d` · [Anleitung](../../MANUAL.de.md#git-und-projektterminals) |
| [![Änderungsverlauf](undo.png)](undo.png) | **Änderungsverlauf** — Verzweigungen des Rückgängig-Verlaufs neben dem geöffneten Puffer. | `Space u u` · [Anleitung](../../MANUAL.de.md#bearbeiten-und-tastenkürzel) |

## Terminals und Werkzeuge

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Projektterminal](terminal.png)](terminal.png) | **Projektterminal** — Projektterminal unter dem Code mit einer Verzeichnisauflistung. | `Space t t` · [Anleitung](../../MANUAL.de.md#git-und-projektterminals) |
| [![Schwebendes Terminal](floating_terminal.png)](floating_terminal.png) | **Schwebendes Terminal** — Ein Terminal schwebt über dem Editor; der Code bleibt sichtbar. | `Space t f` · [Anleitung](../../MANUAL.de.md#git-und-projektterminals) |
| [![Cloud-Sprachen bearbeiten](cloud_languages.png)](cloud_languages.png) | **Cloud-Sprachen bearbeiten** — Terraform und Azure-Pipelines-YAML nebeneinander geöffnet. | `:vsplit azure-pipelines.yml` · [Anleitung](../../MANUAL.de.md#azure-und-cloud-werkzeuge) |
| [![Hintergrundbildmanager](wallpapers.png)](wallpapers.png) | **Hintergrundbildmanager** — Wallpaper Manager mit Bildauswahl, Favoriten, Zufallsauswahl und Startoptionen. | `Space u b` · [Anleitung](../../nvim/backgrounds/README.de.md) |
| [![Pluginverwaltung](plugins.png)](plugins.png) | **Pluginverwaltung** — Lazy listet installierte Plugins und ihren Ladestatus auf. | `:Lazy` · [Anleitung](../../MANUAL.de.md#pluginverwaltung) |
| [![Sprachwerkzeugverwaltung](language_tools.png)](language_tools.png) | **Sprachwerkzeugverwaltung** — Mason listet installierte und verfügbare Sprachwerkzeuge auf. | `:Mason` · [Anleitung](../../MANUAL.de.md#sprachunterstützung-und-formatierung) |
| [![Debug-Fenster (keine aktive Sitzung)](debug.png)](debug.png) | **Debug-Fenster (keine aktive Sitzung)** — Debug-Fenster um Python-Code angeordnet; keine laufende Sitzung. | `F5` · [Anleitung](../../MANUAL.de.md#python-debugging) |

## KI-Arbeitsbereiche

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Claude-Sitzungen (Ersteinrichtung)](claude_sessions.png)](claude_sessions.png) | **Claude-Sitzungen (Ersteinrichtung)** — Zwei übereinander angeordnete Claude-Terminals bei der Ersteinrichtung; keine laufende Aufgabe. | `:Claude 2` · [Anleitung](../../MANUAL.de.md#arbeitsbereiche-für-ki-sitzungen) |
| [![Codex-Sitzungen (leere Vorschau)](codex_sessions.png)](codex_sessions.png) | **Codex-Sitzungen (leere Vorschau)** — Zwei übereinander angeordnete Terminalpuffer zeigen das Layout; die Vorschauen sind leer. | `:Codex 2` · [Anleitung](../../MANUAL.de.md#arbeitsbereiche-für-ki-sitzungen) |

## Japanisches Schreibprofil

| Vorschau | Funktion | Ausprobieren / Anleitung |
| --- | --- | --- |
| [![Japanisch-Lerndashboard](japanese_dashboard.png)](japanese_dashboard.png) | **Japanisch-Lerndashboard** — Lern-Tastenkürzel für Tagebuch, Vokabeln, Referenzen und Wiederholung. | `:JPDashboard` · [Anleitung (Englisch)](../../nvim-jp/JP-HELP.md#commands) |
| [![Kana-Übersicht](japanese_kana.png)](japanese_kana.png) | **Kana-Übersicht** — Hiragana, Katakana und Romaji in einer Referenztabelle. | `:JPKanaChart` · [Anleitung (Englisch)](../../nvim-jp/JP-HELP.md#commands) |
| [![Kanji-Übersicht](japanese_kanji.png)](japanese_kanji.png) | **Kanji-Übersicht** — Kanji der ersten Schulstufe mit Lesebeispielen und englischer Bedeutung. | `:JPKanjiList` · [Anleitung (Englisch)](../../nvim-jp/JP-HELP.md#commands) |
| [![Japanisch schreiben](japanese_writing.png)](japanese_writing.png) | **Japanisch schreiben** — Japanische Schreibprobe mit Vokabeltabelle und Übungscheckliste. | `:JPWriting` · [Anleitung (Englisch)](../../nvim-jp/JP-HELP.md#commands) |
