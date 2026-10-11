# Hintergrundbilder für Windows

**Sprachen:** [English](README.md) | [Français](README.fr.md) | Deutsch | [日本語](README.ja.md)

Lege deine Hintergrundbilder in diesem Ordner oder dessen Unterordnern ab. Die Auswahl unterstützt PNG, JPG/JPEG, GIF, BMP und WebP. Quellen der enthaltenen Bilder stehen in den [Bildnachweisen](CREDITS.de.md).

Bilder aus [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) wurden entfernt, weil die Hintergrundsammlung ersetzt wurde. Die Nachweisdatei behält einen Link zu dieser früheren Sammlung.

<a id="choose-a-wallpaper"></a>

## Hintergrundbild auswählen

Verwende in Neovim diese Befehle oder Kürzel:

| Befehl | Tasten | Aktion |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | Hintergrundbild auswählen |
| `:BackgroundFolder` | Space u B | Bildordner im Windows-Explorer öffnen |

Die Auswahl durchsucht diesen Ordner und dessen Unterordner. Sie nutzt fzf-lua, wenn verfügbar, sonst Neovims eingebaute Auswahl. SVG-Dateien werden nicht gelistet.

Deine Auswahl wird als **relativer Bildpfad**, etwa `Magi/01-Magi-Star.jpg`, in `selected-background.txt` gespeichert. Git ignoriert diese erzeugte Datei. Abbrechen behält die vorherige Auswahl.

<a id="use-a-different-image-folder"></a>

## Anderen Bildordner verwenden

Der Standardordner ist Neovims `stdpath("config")` plus `backgrounds`, unter Windows normalerweise `$env:LOCALAPPDATA\nvim\backgrounds`. Setze `NVIM_BACKGROUND_DIR` in Neovim und WezTerm auf denselben absoluten Ordner oder denselben zum Benutzerordner relativen Pfad `~/...`. Starte nach der Änderung beide Anwendungen neu.

<a id="display-the-wallpaper-in-wezterm"></a>

## Hintergrundbild in WezTerm anzeigen

Installiere die enthaltene [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) unter `$HOME\.wezterm.lua`. WezTerm liest die Auswahl und zeigt bei aktivem Neovim ein abgedunkeltes Hintergrundbild. Das Terminalfenster bleibt undurchsichtig; das Bild wird für lesbaren Text gedimmt.

Eine leere Auswahl oder ein fehlendes Bild stellt das normale Terminalaussehen wieder her. Ältere Auswahlen mit absoluten Pfaden funktionieren lokal weiterhin. Die nächste Hintergrundauswahl ersetzt diesen Pfad durch einen relativen.

Siehe [Windows-Handbuch](../../MANUAL.de.md#wezterm-and-wallpapers) und [aktuelle Bildquellen](CREDITS.de.md).
