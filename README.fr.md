# Configuration de Neovim et WezTerm pour Windows

**Langues :** [English](README.md) | Français | [Deutsch](README.de.md) | [日本語](README.ja.md)

> **Note personnelle :** J’apprends actuellement le français et le japonais.

**Cette configuration est destinée à Windows.** Elle réunit Neovim, PowerShell et WezTerm pour modifier du code, travailler avec Git et déboguer Python. Elle comprend un explorateur de fichiers, la complétion, des serveurs de langage, le rendu Markdown et une intégration facultative avec Obsidian.

Elle prend également en charge Azure/Bicep, Terraform, YAML et Bash, l’édition de tableaux CSV/TSV, des sessions dédiées à Codex et Claude, les aperçus d’images et de PDF ainsi que les fonds d’écran du terminal.

Dépôt source : [Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config).

Les chemins sont résolus automatiquement pour l’utilisateur Windows actuel. Vous pouvez donc utiliser cette configuration sans ajouter votre nom d’utilisateur ni une lettre de lecteur fixe.

Consultez le [manuel utilisateur Windows](MANUAL.fr.md) pour la liste complète des raccourcis, la configuration des langages, les fonds d’écran, la personnalisation et le dépannage.

<a id="requirements"></a>

## Prérequis

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 ou version ultérieure**.
- [Git pour Windows](https://git-scm.com/downloads/win), [fzf](https://github.com/junegunn/fzf) et [ripgrep](https://github.com/BurntSushi/ripgrep), disponibles dans `PATH`.
- [WezTerm](https://wezterm.org/installation.html) pour le fond d’écran du terminal et l’intégration de Ctrl+Tab ; Neovim fonctionne également sans ces fonctionnalités du terminal.
- PowerShell 7 est le shell recommandé. Windows PowerShell est également pris en charge pour les services de l’éditeur et l’indicateur d’utilisation du processeur.
- Pour les analyseurs syntaxiques : Tree-sitter CLI **0.26.1 ou version ultérieure**, `curl`, `tar` et un compilateur C dans `PATH`, par exemple MSVC dans une session Developer PowerShell ou Clang. Ces prérequis correspondent à ceux de la [version verrouillée de Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md).
- Python, Node.js/npm et un JDK selon les outils de langage décrits dans le manuel. Une Nerd Font est facultative pour afficher les icônes.

<a id="install-on-windows"></a>

## Installation sous Windows

Téléchargez ce dépôt ou clonez-le depuis PowerShell :

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```
Fermez Neovim, puis ouvrez PowerShell dans le dossier du dépôt et exécutez les commandes ci-dessous. Toute configuration existante est déplacée vers une sauvegarde horodatée avant la copie des nouveaux fichiers. Les données des plugins installés sont conservées.

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
Neovim utilise normalement `$env:LOCALAPPDATA\nvim`. WezTerm lit `$HOME\.wezterm.lua`. Redémarrez WezTerm, lancez `nvim` et laissez les téléchargements initiaux des plugins et des outils se terminer. Ouvrez un fichier source pour déclencher l’installation du serveur de langage. Redémarrez Neovim après la première installation, puis exécutez `:checkhealth` et `:Mason`.

<a id="useful-shortcuts"></a>

## Raccourcis utiles

La touche leader est **Espace**. Appuyez successivement sur les touches indiquées ; par exemple, `Space f f` ouvre le sélecteur de fichiers. Appuyez sur Espace et attendez pour afficher l’aide de Which-Key.

| Touches | Action |
| --- | --- |
| Ctrl+S | Enregistrer le fichier actuel |
| Ctrl+B | Afficher ou masquer l’explorateur de fichiers |
| Ctrl+P / Space f f | Rechercher un fichier |
| Space f g | Rechercher du texte dans le projet |
| Ctrl+Tab / Ctrl+Shift+Tab | Fichier suivant / précédent dans WezTerm |
| Space b c | Fermer le fichier actuel |
| Space c f | Formater le fichier actuel |
| Space g g | Ouvrir l’état Git |
| Space u b | Choisir un fond d’écran du terminal |
| Space t t | Afficher ou masquer un terminal du projet |
| Space c v | Activer ou désactiver l’affichage tabulaire CSV/TSV |
| Space z t | Ouvrir un terminal du projet pour Azure |

Utilisez `:Codex 8` ou `:Claude 8` pour ouvrir huit sessions CLI indépendantes dans un onglet Neovim dédié. L’ouverture d’une image ou d’un PDF crée un onglet d’aperçu WezTerm distinct. Installez les outils externes requis avant d’utiliser ces fonctionnalités ; consultez le [manuel](MANUAL.fr.md#ai-session-workspaces) et le [guide de configuration cloud](nvim/SETUP-CLOUD-TOOLS.fr.md).

<a id="files-and-sharing"></a>

## Fichiers et partage

- `nvim/` contient la configuration Neovim à installer.
- `WezTerminal-Config/.wezterm.lua` est la configuration complémentaire du terminal Windows.
- [MANUAL.md](MANUAL.fr.md) explique toutes les fonctionnalités configurées et les paramètres locaux.
- `nvim/lazy-lock.json` consigne les révisions des plugins ; conservez-le lorsque vous partagez la configuration.

Les fonds d’écran sélectionnés utilisent des chemins relatifs au dossier des images. Git ignore le fichier de sélection, les journaux, les fichiers temporaires, les fichiers d’environnement locaux ainsi que les fichiers d’état et de plan Terraform. Définissez les chemins personnels à l’aide de variables d’environnement locales telles que `OBSIDIAN_VAULT` et `NVIM_BACKGROUND_DIR`.

Les images de [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) ont été retirées, car la collection de fonds d’écran a été remplacée. Les sources des images actuelles figurent dans les [crédits des fonds d’écran](nvim/backgrounds/CREDITS.fr.md).

Avant de partager de nouvelles modifications, exécutez les [commandes de validation](MANUAL.fr.md#validate-the-configuration) et vérifiez les personnalisations personnelles que vous avez ajoutées.
