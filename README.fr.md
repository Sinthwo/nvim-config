# Configuration de Neovim et WezTerm pour Windows

**Langues :** [English](README.md) | Français | [Deutsch](README.de.md) | [日本語](README.ja.md)

Une configuration Windows pour Neovim, PowerShell et WezTerm avec explorateur
de fichiers, complétion, serveurs de langage, outils Git et débogage Python.

Les outils facultatifs ajoutent le développement cloud, les sessions IA dans le
terminal, Markdown et Obsidian, l’écriture japonaise, les aperçus d’images et les
fonds d’écran. Consultez le [manuel Windows](MANUAL.fr.md) pour la référence complète.

**Accès rapide :** [Installation sous Windows](#installation-sous-windows) · [Première session réussie](#première-session-réussie) · [Mise à jour et restauration](MANUAL.fr.md#mise-à-jour-et-restauration) · [Raccourcis utiles](#raccourcis-utiles) · [Fonctionnalités facultatives](#fonctionnalités-facultatives) · [Fichiers et partage](#fichiers-et-partage)

## Captures d’écran

| Tableau de bord | Éditeur et explorateur de fichiers |
| --- | --- |
| [![Tableau de bord de Neovim avec un requin et des raccourcis](docs/screenshots/dashboard.png)](docs/screenshots/dashboard.png) | [![Fichier Lua ouvert dans Neovim à côté de l’explorateur](docs/screenshots/editor-explorer.png)](docs/screenshots/editor-explorer.png) |

La [galerie des fonctionnalités](docs/screenshots/README.fr.md) présente les 31 captures, notamment le gestionnaire de fonds d’écran et le profil d’écriture japonaise.

## Prérequis

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 ou version ultérieure**.
- [Git pour Windows](https://git-scm.com/downloads/win), [fzf](https://github.com/junegunn/fzf) et [ripgrep](https://github.com/BurntSushi/ripgrep), disponibles dans `PATH`.
- [WezTerm](https://wezterm.org/installation.html) pour le fond d’écran du terminal et l’intégration de `Ctrl+Tab` ; Neovim fonctionne également sans ces fonctionnalités du terminal.
- PowerShell 7 est le shell recommandé. Windows PowerShell est également pris en charge pour les services de l’éditeur et l’indicateur d’utilisation du processeur.
- Pour les analyseurs syntaxiques : Tree-sitter CLI **0.26.1 ou version ultérieure**, `curl`, `tar` et un compilateur C dans `PATH`, par exemple MSVC dans une session Developer PowerShell ou Clang. Ces prérequis correspondent à ceux de la [version verrouillée de Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter/blob/a2f694478be07f89c2d03cc17858a8745a400c4b/README.md).
- Python, Node.js/npm et un JDK selon les outils de langage décrits dans le manuel. Une Nerd Font est facultative pour afficher les icônes.

## Installation sous Windows

Téléchargez ce dépôt ou clonez-le depuis PowerShell :

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```

Fermez Neovim, puis ouvrez PowerShell dans le dossier du dépôt et exécutez les commandes ci-dessous. Toute configuration existante est déplacée vers une sauvegarde horodatée avant la copie des nouveaux fichiers. Les données des plugins installés sont conservées.

Les commandes s’arrêtent si une opération sur les fichiers échoue. Conservez le chemin de sauvegarde affiché.
Pour une installation existante, consultez d’abord [Mise à jour et restauration](MANUAL.fr.md#mise-à-jour-et-restauration)
pour conserver vos réglages locaux.

```powershell
# Ask the executable directly, bypassing any PowerShell profile launcher.
$nvimDir = (& nvim.exe --headless -u NONE -i NONE -n --cmd 'lua io.write(vim.fn.stdpath("config"))' +qa).Trim()
if ($LASTEXITCODE -ne 0 -or -not $nvimDir) { throw 'Could not find the Neovim config directory.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$nvimBackup = "$nvimDir.backup-$stamp"
if (Test-Path -LiteralPath $nvimDir) {
    Move-Item -LiteralPath $nvimDir -Destination $nvimBackup -ErrorAction Stop
    Write-Host "Neovim backup: $nvimBackup"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $nvimDir) -Force -ErrorAction Stop | Out-Null
Copy-Item -LiteralPath '.\nvim' -Destination $nvimDir -Recurse -ErrorAction Stop
```

### Facultatif : configuration WezTerm

Exécutez ce bloc séparément uniquement pour remplacer votre configuration WezTerm.
Le fichier existant est sauvegardé au préalable.

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$weztermFile = Join-Path $HOME '.wezterm.lua'
if (Test-Path -LiteralPath $weztermFile) {
    $weztermBackup = "$weztermFile.backup-$stamp"
    Move-Item -LiteralPath $weztermFile -Destination $weztermBackup -ErrorAction Stop
    Write-Host "WezTerm backup: $weztermBackup"
}
Copy-Item -LiteralPath '.\WezTerminal-Config\.wezterm.lua' -Destination $weztermFile -ErrorAction Stop
```

Neovim utilise normalement `$env:LOCALAPPDATA\nvim`. WezTerm lit `$HOME\.wezterm.lua`. Redémarrez WezTerm, lancez `nvim` et laissez les téléchargements initiaux des plugins et des outils se terminer. Ouvrez un fichier source pour déclencher l’installation du serveur de langage. Redémarrez Neovim après la première installation, puis exécutez `:checkhealth` et `:Mason`.

## Première session réussie

Ouvrez WezTerm dans un projet Git d’essai et lancez `nvim README.md`. Attendez
les téléchargements initiaux, redémarrez Neovim et revenez au projet. Utilisez
le mode normal (`Esc`) pour les raccourcis ; saisissez les séquences Space touche par touche.

| Essai | Résultat attendu |
| --- | --- |
| Appuyer sur `Space f f`, saisir une partie du nom, puis `Enter` | Le sélecteur ouvre le fichier choisi. |
| Avec `Space f g`, chercher un texte présent dans le projet | Les résultats apparaissent avec un aperçu ; `Esc` ferme le sélecteur. |
| Appuyer sur `i`, modifier le texte, puis `Esc` et `Ctrl+S` | Le fichier est enregistré ; l’indicateur de modification disparaît. |
| Ouvrir un fichier Lua et appuyer sur `Space c f` | StyLua le formate une fois son installation Mason terminée. |
| Appuyer sur `Space g g` | Neogit affiche les fichiers modifiés ; `:close` revient à l’éditeur. |

Utilisez un fichier d’essai pour modifier et formater du texte. En cas d’échec,
consultez `:messages`, `:Mason` et `:ConformInfo`, puis le [dépannage](MANUAL.fr.md#dépannage).
Le [manuel](MANUAL.fr.md) explique les autres commandes.

## Raccourcis utiles

La touche leader est **Espace**. Appuyez successivement sur les touches indiquées ; par exemple, `Space f f` ouvre le sélecteur de fichiers. Appuyez sur Espace et attendez pour afficher l’aide de Which-Key.

| Touches | Action |
| --- | --- |
| `Ctrl+S` | Enregistrer le fichier actuel |
| `Ctrl+B` | Afficher ou masquer l’explorateur de fichiers |
| `Ctrl+P` / `Space f f` | Rechercher un fichier |
| `Space f g` | Rechercher du texte dans le projet |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Fichier suivant / précédent dans WezTerm |
| `Space b c` | Fermer le fichier actuel |
| `Space c f` | Formater le fichier actuel |
| `Space g g` | Ouvrir l’état Git |
| `Space u b` | Choisir un fond d’écran du terminal |
| `Space t t` | Afficher ou masquer un terminal du projet |
| `Space c v` | Activer ou désactiver l’affichage tabulaire CSV/TSV |
| `Space z t` | Ouvrir un terminal du projet pour Azure |

Utilisez `:Codex 8` ou `:Claude 8` pour ouvrir huit sessions CLI indépendantes dans un onglet Neovim dédié. L’ouverture d’une image ou d’un PDF crée un onglet d’aperçu WezTerm distinct. Installez les outils externes requis avant d’utiliser ces fonctionnalités ; consultez le [manuel](MANUAL.fr.md#espaces-de-travail-des-sessions-ia) et le [guide de configuration cloud](nvim/SETUP-CLOUD-TOOLS.fr.md).

## Fonctionnalités facultatives

Examinez les modifications avec `:CodeDiff` ou `:MiniDiffOverlay`, affichez les noms
des fichiers dans les fenêtres avec `:InclineToggle` et ouvrez un dossier modifiable avec `:Oil`.
Utilisez `:AICopyPath` ou `:AICopyContext` pour copier des références de code pour les outils IA.
Le formatage Web et Markdown utilise prettierd ou prettier, selon leur disponibilité.
Consultez les [notes de mise à jour (anglais)](nvim/UPGRADE_NOTES.md) pour les détails.

`Space u b` ouvre le gestionnaire de fonds d’écran : dossiers, favoris, sélection aléatoire
et modes de démarrage. Par défaut, une image est choisie aléatoirement au démarrage ;
Manual dans Settings conserve l’image. `Space m p` active l’aperçu Markdown/Mermaid dans le navigateur.

Le profil facultatif `nvim-jp/` ajoute écriture japonaise, vocabulaire, Kana/Kanji
et notes Obsidian. Le lanceur PowerShell propose Coding/Japanese lorsque `nvim`
interactif n’a aucun argument ; `nvim-code` et `nvim-jp` choisissent directement.
Voir l’[installation des profils (anglais)](NeovimProfiles/README.md) et le
[manuel](MANUAL.fr.md#profil-décriture-japonaise). Réglages personnels, favoris,
et mode de démarrage sont ignorés par Git.

Le tableau de bord propose des raccourcis pour les fichiers, la recherche,
les plugins et les terminaux. Consultez [Tableau de bord et notifications](MANUAL.fr.md#tableau-de-bord-et-notifications)
pour ses commandes et les [espaces de travail IA](MANUAL.fr.md#espaces-de-travail-des-sessions-ia)
pour sélectionner ou agrandir les sessions en cours.

## Fichiers et partage

- `nvim/` contient la configuration Neovim à installer.
- `WezTerminal-Config/.wezterm.lua` est la configuration complémentaire du terminal Windows.
- [MANUAL.fr.md](MANUAL.fr.md) explique toutes les fonctionnalités configurées et les paramètres locaux.
- `nvim/lazy-lock.json` consigne les révisions des plugins ; conservez-le lorsque vous partagez la configuration.

Dépôt source : [Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config).
Les chemins sont résolus pour l’utilisateur Windows actuel, sans nom
d’utilisateur ni lettre de lecteur fixe.

> **Note personnelle :** J’apprends actuellement le français et le japonais.

Les fonds d’écran sélectionnés utilisent des chemins relatifs au dossier des images. Git ignore le fichier de sélection, les journaux, les fichiers temporaires, les fichiers d’environnement locaux ainsi que les fichiers d’état et de plan Terraform. Définissez les chemins personnels à l’aide de variables d’environnement locales telles que `OBSIDIAN_VAULT` et `NVIM_BACKGROUND_DIR`.

Les sources des images actuelles figurent dans les [crédits des fonds d’écran](nvim/backgrounds/CREDITS.fr.md).

Avant de partager de nouvelles modifications, exécutez les [commandes de validation](MANUAL.fr.md#validation-de-la-configuration) et vérifiez les personnalisations personnelles que vous avez ajoutées.
