# Images de fond pour Windows

**Langues :** [English](README.md) | Français | [Deutsch](README.de.md) | [日本語](README.ja.md)

Placez vos fonds d’écran dans ce dossier ou ses sous-dossiers. Le sélecteur prend en charge PNG, JPG/JPEG, GIF, BMP et WebP. Les sources des images incluses figurent dans les [crédits](CREDITS.fr.md).

[![Gestionnaire de fonds d’écran avec navigation et favoris](../../docs/screenshots/wallpapers.png)](../../docs/screenshots/wallpapers.png)

La [galerie de captures d’écran](../../docs/screenshots/README.fr.md) présente d’autres vues de la configuration.

## Choisir un fond d’écran

Dans Neovim, utilisez ces commandes ou raccourcis :

| Commande | Touches | Action |
| --- | --- | --- |
| `:BackgroundPick` | `Space u b` | Choisir un fond d’écran |
| `:BackgroundFolder` | `Space u B` | Ouvrir le dossier des images dans l’Explorateur Windows |

`Space u b` ouvre Wallpaper Manager : Browse wallpapers parcourt les dossiers,
Favorites gère les favoris, Shuffle now choisit une autre image et Settings
définit le comportement au démarrage. Catégories : `Anime/`, `Games/`, `Real World/`,
`Other/`. Les images sont dans `Anime/<titre>/Images/` et les animations dans `GIFs/`.
PNG, JPG/JPEG, GIF, BMP et WebP sont pris en charge ; SVG est exclu.
Le menu utilise Snacks, avec `vim.ui.select` en secours.

### Modes de démarrage

| Mode | Comportement |
| --- | --- |
| `random` (par défaut) | Choisir une image à chaque démarrage interactif, différente de l’actuelle si possible |
| `random_favorite` | Choisir parmi les favoris ; au moins un favori est nécessaire |
| `manual` | Conserver l’image ; choisir une image manuellement active aussi ce mode |

Utilisez `:BackgroundMode random`, `:BackgroundMode random_favorite` ou
`:BackgroundMode manual` pour définir le mode. Les modes aléatoires appliquent
immédiatement une image. Les sessions headless ne changent pas l’image au démarrage.

| Commande | Action |
| --- | --- |
| `:BackgroundRandom` | Choisir une image aléatoire une fois |
| `:BackgroundFavorite` | Ajouter ou retirer l’image active des favoris |
| `:BackgroundFavorites` | Parcourir les favoris |

Ces trois commandes conservent le mode de démarrage. Annuler un menu conserve
l’image et le mode actuels.

### Sélection locale

`background-mode.txt`, `favorite-backgrounds.txt` et `selected-background.txt`
restent locaux et ignorés par Git. Favoris et sélection utilisent des chemins
relatifs, par exemple `Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg`.
Les anciens chemins absolus restent valides et deviennent relatifs lors de leur réécriture.

## Utiliser un autre dossier d’images

Le dossier par défaut est le `stdpath("config")` de Neovim suivi de `backgrounds`, normalement `$env:LOCALAPPDATA\nvim\backgrounds` sous Windows. Définissez `NVIM_BACKGROUND_DIR` sur le même répertoire absolu, ou le même chemin relatif au dossier utilisateur `~/...`, dans Neovim et WezTerm. Redémarrez les deux applications après la modification.

Pour un réglage utilisateur persistant, exécutez ce bloc dans PowerShell, ajoutez
les images au dossier, puis redémarrez complètement WezTerm et Neovim pour en hériter.

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force -ErrorAction Stop | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```

## Afficher le fond d’écran dans WezTerm

Installez le fichier fourni [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) à `$HOME\.wezterm.lua`. WezTerm lit votre sélection et affiche un fond d’écran assombri pendant que Neovim est actif. La fenêtre du terminal reste opaque et l’image est assombrie pour garder le texte lisible.

Une sélection vide ou une image absente rétablit l’apparence normale du terminal.

Consultez le [manuel Windows](../../MANUAL.fr.md#wezterm-et-fonds-décran) et les [sources des images actuelles](CREDITS.fr.md).
