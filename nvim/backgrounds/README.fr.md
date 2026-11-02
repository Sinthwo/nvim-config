# Images de fond pour Windows

**Langues :** [English](README.md) | Français | [Deutsch](README.de.md) | [日本語](README.ja.md)

Placez vos fonds d’écran dans ce dossier ou ses sous-dossiers. Le sélecteur prend en charge PNG, JPG/JPEG, GIF, BMP et WebP. Les sources des images incluses figurent dans les [crédits](CREDITS.fr.md).

## Choisir un fond d’écran

Dans Neovim, utilisez ces commandes ou raccourcis :

| Commande | Touches | Action |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | Choisir un fond d’écran |
| `:BackgroundFolder` | Space u B | Ouvrir le dossier des images dans l’Explorateur Windows |

Space u b ouvre Wallpaper Manager : Browse wallpapers parcourt les dossiers,
Favorites gère les favoris, Shuffle now choisit une autre image et Settings
définit le comportement au démarrage. Catégories : `Anime/`, `Games/`, `Real World/`,
`Other/`. Les images sont dans `Anime/<titre>/Images/` et les animations dans `GIFs/`.
PNG, JPG/JPEG, GIF, BMP et WebP sont pris en charge ; SVG est exclu.
Le menu utilise Snacks, avec `vim.ui.select` en secours.

Le mode initial est `random` : chaque démarrage interactif choisit une image,
différente de l’actuelle si possible. `random_favorite` ne choisit que les favoris
et en nécessite au moins un. `manual` conserve l’image ; choisir une image
manuellement active aussi ce mode. Les sessions headless ne changent pas l’image.
`:BackgroundMode random`, `:BackgroundMode random_favorite` et `:BackgroundMode manual`
changent le mode ; les modes aléatoires appliquent immédiatement une image.
`:BackgroundRandom` mélange une fois, `:BackgroundFavorite` marque l’image active,
`:BackgroundFavorites` parcourt les favoris. Ces trois commandes gardent le mode de démarrage.

`background-mode.txt`, `favorite-backgrounds.txt` et `selected-background.txt`
restent locaux et ignorés par Git. Favoris et sélection utilisent des chemins
relatifs ; les anciens chemins absolus sont lus puis deviennent relatifs lors
de leur réécriture. Annuler un menu ne change ni l’image ni le mode.

Votre choix est enregistré dans `selected-background.txt` comme **chemin d’image relatif**, par exemple `Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg`. Git ignore ce fichier généré. Annuler le sélecteur conserve le choix précédent.

## Utiliser un autre dossier d’images

Le dossier par défaut est le `stdpath("config")` de Neovim suivi de `backgrounds`, normalement `$env:LOCALAPPDATA\nvim\backgrounds` sous Windows. Définissez `NVIM_BACKGROUND_DIR` sur le même répertoire absolu, ou le même chemin relatif au dossier utilisateur `~/...`, dans Neovim et WezTerm. Redémarrez les deux applications après la modification.

## Afficher le fond d’écran dans WezTerm

Installez le fichier fourni [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) à `$HOME\.wezterm.lua`. WezTerm lit votre sélection et affiche un fond d’écran assombri pendant que Neovim est actif. La fenêtre du terminal reste opaque et l’image est assombrie pour garder le texte lisible.

Une sélection vide ou une image absente rétablit l’apparence normale du terminal. Les anciennes sélections contenant un chemin absolu fonctionnent encore localement. Choisir un autre fond d’écran remplace ce chemin par un chemin relatif.

Consultez le [manuel Windows](../../MANUAL.fr.md#wezterm-et-fonds-décran) et les [sources des images actuelles](CREDITS.fr.md).
