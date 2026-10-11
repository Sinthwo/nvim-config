# Images de fond pour Windows

**Langues :** [English](README.md) | Français | [Deutsch](README.de.md) | [日本語](README.ja.md)

Placez vos fonds d’écran dans ce dossier ou ses sous-dossiers. Le sélecteur prend en charge PNG, JPG/JPEG, GIF, BMP et WebP. Les sources des images incluses figurent dans les [crédits](CREDITS.fr.md).

Les images de [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) ont été retirées, car la collection de fonds d’écran a été remplacée. Le fichier de crédits conserve un lien vers cette ancienne collection.

<a id="choose-a-wallpaper"></a>

## Choisir un fond d’écran

Dans Neovim, utilisez ces commandes ou raccourcis :

| Commande | Touches | Action |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | Choisir un fond d’écran |
| `:BackgroundFolder` | Space u B | Ouvrir le dossier des images dans l’Explorateur Windows |

Le sélecteur parcourt ce dossier et ses sous-dossiers. Il utilise fzf-lua lorsqu’il est disponible, sinon le sélecteur intégré de Neovim. Les fichiers SVG ne sont pas affichés.

Votre choix est enregistré dans `selected-background.txt` comme **chemin d’image relatif**, par exemple `Magi/01-Magi-Star.jpg`. Git ignore ce fichier généré. Annuler le sélecteur conserve le choix précédent.

<a id="use-a-different-image-folder"></a>

## Utiliser un autre dossier d’images

Le dossier par défaut est le `stdpath("config")` de Neovim suivi de `backgrounds`, normalement `$env:LOCALAPPDATA\nvim\backgrounds` sous Windows. Définissez `NVIM_BACKGROUND_DIR` sur le même répertoire absolu, ou le même chemin relatif au dossier utilisateur `~/...`, dans Neovim et WezTerm. Redémarrez les deux applications après la modification.

<a id="display-the-wallpaper-in-wezterm"></a>

## Afficher le fond d’écran dans WezTerm

Installez le fichier fourni [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) à `$HOME\.wezterm.lua`. WezTerm lit votre sélection et affiche un fond d’écran assombri pendant que Neovim est actif. La fenêtre du terminal reste opaque et l’image est assombrie pour garder le texte lisible.

Une sélection vide ou une image absente rétablit l’apparence normale du terminal. Les anciennes sélections contenant un chemin absolu fonctionnent encore localement. Choisir un autre fond d’écran remplace ce chemin par un chemin relatif.

Consultez le [manuel Windows](../../MANUAL.fr.md#wezterm-and-wallpapers) et les [sources des images actuelles](CREDITS.fr.md).
