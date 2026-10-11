# Manuel utilisateur Windows

**Langues :** [English](MANUAL.md) | Français | [Deutsch](MANUAL.de.md) | [日本語](MANUAL.ja.md)

**Cette configuration Neovim et WezTerm est destinée à Windows.** Ce manuel couvre l’installation, les raccourcis courants, les outils facultatifs et la personnalisation. Les exemples utilisent PowerShell et résolvent les chemins pour l’utilisateur actuel.

<a id="contents"></a>

## Sommaire

- [Installation et premier lancement](#installation-and-first-launch)
- [Édition et raccourcis](#editing-and-shortcuts)
- [Recherche de fichiers et explorateur](#finding-files-and-using-the-explorer)
- [Prise en charge des langages et formatage](#language-support-and-formatting)
- [Débogage Python](#python-debugging)
- [Git et terminaux du projet](#git-and-project-terminals)
- [Espaces de travail des sessions IA](#ai-session-workspaces)
- [Azure et outils cloud](#azure-and-cloud-tools)
- [Tableaux CSV et TSV](#csv-and-tsv-tables)
- [Aperçus d’images et de PDF](#image-and-pdf-previews)
- [Markdown et Obsidian](#markdown-and-obsidian)
- [WezTerm et fonds d’écran](#wezterm-and-wallpapers)
- [Personnalisation et confidentialité](#customization-and-privacy)
- [Gestion des plugins](#plugin-management)
- [Dépannage](#troubleshooting)
- [Validation de la configuration](#validate-the-configuration)

<a id="installation-and-first-launch"></a>

## Installation et premier lancement

Suivez les [étapes d’installation du README](README.fr.md#install-on-windows). La commande de copie place les fichiers directement dans le répertoire de configuration Neovim. Vérifiez qu’elle n’a pas créé de dossier `nvim` supplémentaire dans ce répertoire. Le premier lancement nécessite une connexion Internet pour télécharger les plugins et les outils de langage.

Après l’installation d’outils en ligne de commande, ouvrez une nouvelle fenêtre PowerShell pour récupérer le `PATH` mis à jour. Vérifiez la disponibilité des outils principaux :

```powershell
nvim --version
git --version
fzf --version
rg --version
wezterm --version
```
La version verrouillée de Tree-sitter [nécessite](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md) Neovim 0.12 ou version ultérieure, Tree-sitter CLI 0.26.1 ou version ultérieure, `curl`, `tar` et un compilateur C. Mason installe automatiquement la CLI. Installez le compilateur séparément. Si vous utilisez MSVC, lancez WezTerm depuis Developer PowerShell afin que Neovim trouve le compilateur et son environnement.

L’installation du serveur de langage démarre à l’ouverture d’un fichier source. Les outils de formatage et debugpy commencent à s’installer peu après le démarrage. Gardez la première session ouverte jusqu’à ce que `:Lazy` et `:Mason` indiquent la fin des installations, puis redémarrez Neovim. Neovim retente l’installation des analyseurs après l’installation des outils Mason.

Vérifiez la configuration avec ces commandes :

```vim
:checkhealth
:Mason
:ConformInfo
:messages
```
<a id="editing-and-shortcuts"></a>

## Édition et raccourcis

Neovim propose le mode normal pour naviguer et exécuter des commandes, le mode insertion pour saisir du texte et le mode visuel pour sélectionner. Appuyez sur `i` pour saisir, sur `Esc` pour revenir au mode normal et sur `v` pour sélectionner. Saisissez les commandes avec `:` en mode normal.

La touche leader est **Espace** et la touche leader locale est **la barre oblique inverse**. Un raccourci comme `Space b c` signifie qu’il faut appuyer successivement sur ces touches en mode normal. Les majuscules comptent. Appuyez sur Espace et attendez que Which-Key affiche les raccourcis disponibles.

| Touches ou commande | Action |
| --- | --- |
| Ctrl+S | Enregistrer en mode normal ou insertion |
| `:w` / `:q` / `:wq` | Enregistrer / fermer la fenêtre / enregistrer et fermer |
| Esc | Effacer la surbrillance de recherche en mode normal |
| `/text`, puis `n` / `N` | Rechercher, résultat suivant / précédent |
| `u` / Ctrl+R | Annuler / rétablir |
| Ctrl+H / J / K / L | Activer la division gauche / inférieure / supérieure / droite |
| Space s v / Space s h | Créer une division verticale / horizontale |
| Space s c | Fermer la division actuelle |
| Ctrl+Tab / Ctrl+Shift+Tab | Tampon suivant / précédent, transmis par WezTerm |
| Space b n / Space b p | Tampon suivant / précédent avec la touche leader |
| Space b P | Choisir un tampon à partir de son étiquette |
| Space b c | Fermer le tampon actuel |
| Space b o | Fermer les autres tampons ; conserver ceux non enregistrés |
| Space b l / Space b r | Fermer les tampons à gauche / à droite |
| Space u u | Afficher ou masquer l’arbre d’historique des annulations |
| Space u z | Activer ou désactiver le mode Zen |
| Space u n | Afficher l’historique des notifications |

Les onglets en haut représentent les **tampons**, généralement des fichiers ouverts. WezTerm possède ses propres onglets de terminal. Enregistrez les fichiers modifiés avant de les fermer pour éviter une demande de confirmation ou un refus de fermeture.

La complétion utilise le [préréglage super-tab](https://cmp.saghen.dev/configuration/keymap) de Blink. Tab accepte une suggestion ou avance dans un extrait ; Shift+Tab recule dans un extrait. Ctrl+Space ouvre la complétion, Ctrl+N/P sélectionne les suggestions et Ctrl+E ferme le menu. La documentation s’ouvre automatiquement après un court délai. L’appariement automatique des délimiteurs et l’édition des caractères d’encadrement sont également activés.

<a id="finding-files-and-using-the-explorer"></a>

## Recherche de fichiers et explorateur

| Touches | Action |
| --- | --- |
| Ctrl+P / Space f f | Rechercher un fichier |
| Ctrl+Shift+F / Space f g | Rechercher du texte dans le projet |
| Space f b | Choisir un tampon ouvert |
| Space f r | Choisir un fichier récent |
| Space f s / Space f S | Symboles du document / de l’espace de travail fournis par le serveur de langage |
| Space f t | Rechercher les commentaires TODO |
| `]t` / `[t` | Commentaire TODO suivant / précédent |
| Ctrl+B | Ouvrir ou fermer l’explorateur de fichiers |

Dans l’explorateur, Entrée ouvre un élément, `v` ou Ctrl+V ouvre une division verticale, et `s` ou Ctrl+S une division horizontale. Ctrl+B ferme l’explorateur. Ctrl+S a donc deux usages : ouvrir une division dans l’explorateur et enregistrer un fichier dans l’éditeur.

L’explorateur suit le fichier actif et affiche les fichiers cachés et ceux ignorés par Git. Les sélecteurs cherchent dans le répertoire de travail actuel. Lancez Neovim depuis le dossier du projet ou utilisez `:cd` pour changer de répertoire. La recherche de texte sous Windows nécessite ripgrep ; consultez les [notes Windows de fzf-lua](https://github.com/ibhagwan/fzf-lua/blob/main/README-Win.md).

<a id="language-support-and-formatting"></a>

## Prise en charge des langages et formatage

Mason installe les outils dans le répertoire de données de Neovim. Voici les langages pris en charge et leurs outils :

| Langage ou fonctionnalité | Outils | Prérequis externes à Neovim |
| --- | --- | --- |
| Python | BasedPyright, Ruff, debugpy | Python ; Node.js/npm pour BasedPyright |
| PowerShell | PowerShell Editor Services | PowerShell, de préférence version 7 |
| Java | jdtls | JDK 21+ pour le serveur, Python 3.9+ pour son lanceur |
| Lua | Serveur de langage Lua, StyLua | Binaires gérés par Mason |
| Formatage JSON / YAML | Prettier | Node.js/npm |
| YAML / Azure Pipelines | yamlls, azure_pipelines_ls | Node.js/npm |
| Bash / scripts shell | bashls, shfmt | Node.js/npm pour le serveur ; Bash pour exécuter les scripts |
| Terraform / HCL | terraformls, terraform_fmt | Terraform CLI pour le formatage et la validation |
| Azure Bicep / paramètres | bicep-ls | SDK .NET et serveur de langage Bicep installé séparément |
| CSV / TSV | csvview.nvim et analyseurs syntaxiques | Aucun serveur externe requis |
| Coloration syntaxique | Analyseurs Tree-sitter | Tree-sitter CLI, curl, tar, compilateur C |

Consultez [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration) pour les prérequis du serveur Java. Votre projet peut cibler une autre version de Java. Les projets Maven et Gradle sont mieux pris en charge que les fichiers Java indépendants.

Ouvrez `:Mason` pour suivre les installations. Vous pouvez aussi installer manuellement les outils configurés :

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
Redémarrez Neovim après l’installation des serveurs de langage. PowerShell Editor Services nécessite un exécutable PowerShell et le script de service fourni par Mason. Java affiche une notification si jdtls est absent.

| Touches | Action du serveur de langage |
| --- | --- |
| `gd` / `gD` | Définition / déclaration |
| `gi` / `gr` | Implémentation / références |
| `K` | Documentation au survol |
| F2 | Renommer un symbole |
| Space c a | Actions de code en mode normal ou visuel |
| Space c d | Diagnostics de la ligne actuelle |
| `]d` / `[d` | Diagnostic suivant / précédent |
| Space x x | Afficher ou masquer les diagnostics du projet |
| Space x X | Afficher ou masquer les diagnostics du tampon actuel |
| Space x s | Afficher ou masquer le panneau des symboles |

Ces raccourcis sont disponibles lorsqu’un serveur de langage est attaché au fichier. Utilisez `:checkhealth vim.lsp` pour vérifier les serveurs et `:messages` pour consulter les erreurs de démarrage.

Le formatage est **manuel** : appuyez sur Space c f. Python utilise Ruff, Lua utilise StyLua, JSON/YAML utilise Prettier, Bash utilise shfmt et Terraform utilise `terraform fmt`. Les autres langages utilisent le formateur du serveur de langage attaché, s’il est disponible. Les fichiers ne sont pas formatés automatiquement à l’enregistrement. Utilisez `:ConformInfo` pour vérifier le formateur disponible pour le fichier actuel.

Pour Java, Space j o organise les imports, Space j v extrait une variable et Space j c extrait une constante. Chaque projet Java possède un cache d’espace de travail distinct, même si deux dossiers portent le même nom. Lors de la première utilisation d’un cache, jdtls peut devoir indexer le projet.

<a id="python-debugging"></a>

## Débogage Python

Ouvrez un fichier Python et vérifiez que l’installation de debugpy dans Mason est terminée. L’adaptateur utilise l’interpréteur debugpy fourni par Mason. Pour l’interpréteur de l’application, activez l’environnement virtuel du projet avant de lancer Neovim ou définissez `require("dap-python").resolve_python` dans votre configuration locale si nécessaire.

| Touches | Action |
| --- | --- |
| F9 | Ajouter ou retirer un point d’arrêt |
| F5 | Démarrer / poursuivre le débogage |
| F10 | Exécuter sans entrer dans la fonction |
| F11 / Shift+F11 | Entrer dans la fonction / en sortir |
| Space d r | Ouvrir le REPL de débogage |
| Space d t | Terminer la session |

L’interface de débogage se charge avec le débogueur, s’ouvre au lancement ou à l’attachement et se ferme à la fin de la session. Sélectionnez une configuration de lancement Python si demandé. Cette configuration prend en charge le débogage Python. Java nécessite un adaptateur et une configuration supplémentaires.

<a id="git-and-project-terminals"></a>

## Git et terminaux du projet

| Touches | Action |
| --- | --- |
| Space g g | Ouvrir l’état Neogit |
| Space g c | Ouvrir l’interface de commit |
| Space g p / Space g P | Push / pull |
| Space g l | Consulter l’historique Git |
| Space g d | Ouvrir une vue des différences |
| Space g H | Consulter l’historique du fichier actuel |
| `]h` / `[h` | Bloc modifié suivant / précédent |
| Space g h | Prévisualiser un bloc modifié |
| Space g s / Space g r | Indexer / réinitialiser le bloc actuel |
| Space g b | Afficher l’auteur de la ligne actuelle |
| Space t t | Afficher ou masquer un terminal à la racine du projet |
| Esc, Esc | Quitter le mode de saisie du terminal |

La réinitialisation d’un bloc abandonne ses modifications. Push et pull utilisent vos identifiants Git et votre configuration distante existants. Cette configuration Neovim ne définit ni nom ni adresse e-mail d’auteur Git.

Le terminal s’ouvre à la racine du projet, identifiée à partir de Git, des fichiers de projet Python, des fichiers de build Java, des paramètres d’analyse PowerShell ou des marqueurs de coffre Obsidian. Sans racine identifiée, il utilise le répertoire de travail actuel.

Space a c lance Codex et Space a C lance Claude Code. Installez les CLI, connectez-vous et assurez-vous que leurs commandes sont disponibles dans `PATH` avant d’utiliser ces raccourcis.

<a id="ai-session-workspaces"></a>

## Espaces de travail des sessions IA

Installez la [CLI Codex](https://learn.chatgpt.com/docs/codex/cli) et/ou [Claude Code](https://code.claude.com/docs/en/setup), puis connectez-vous en suivant leurs instructions. Vérifiez `codex --version` et `claude --version` dans le terminal utilisé pour lancer Neovim. Space a c et Space a C ouvrent chacun un terminal unique. Les commandes suivantes créent un **onglet Neovim** dédié contenant une ou plusieurs sessions :

| Commande | Action |
| --- | --- |
| `:Codex` / `:Claude` | Ouvrir une session CLI |
| `:Codex 8` / `:Claude 8` | Ouvrir huit sessions indépendantes |
| `:Codex1` à `:Codex8` | Ouvrir le nombre indiqué de sessions Codex |
| `:Claude1` à `:Claude8` | Ouvrir le nombre indiqué de sessions Claude |
| `:CodexEnd` / `:ClaudeEnd` | Fermer tous les onglets de travail Codex / Claude |

Le nombre doit être un entier de 1 à 8. `:Codex_8`, `:Claude_8`, `:Codex_End` et `:Claude_End` sont des abréviations interactives de ligne de commande. Dans les scripts et les raccourcis, utilisez les formes sans traits de soulignement.

Votre code reste dans son onglet d’origine. Dans l’onglet IA, Bufferline masque les onglets des fichiers pour laisser place aux sessions. Une session occupe tout l’onglet, deux sont empilées verticalement et de trois à huit sont réparties sur deux colonnes. Chaque session démarre à la racine du projet actuel. Agrandissez le terminal si vous utilisez plusieurs sessions.

Utilisez `gt` et `gT` pour changer d’onglet Neovim. En mode normal, Ctrl+H/J/K/L navigue entre les divisions et `i` active la saisie dans le terminal. Appuyez deux fois sur Esc pour revenir au mode normal.

`:CodexEnd` ferme tous les onglets de travail Codex ; `:ClaudeEnd` ferme tous ceux de Claude. Les deux reviennent à l’onglet de code d’origine s’il est encore ouvert. Fermer une session termine son processus. La connexion, les autorisations et l’utilisation du compte sont gérées par les CLI.

<a id="azure-and-cloud-tools"></a>

## Azure et outils cloud

Suivez le [guide Windows de configuration cloud](nvim/SETUP-CLOUD-TOOLS.fr.md) pour installer facultativement Azure CLI, PowerShell Az, Terraform CLI et le serveur de langage Bicep. Mason gère les serveurs Bash, YAML, Terraform et Azure Pipelines configurés.

| Touches | Commande | Action |
| --- | --- | --- |
| Space z t | `:AzureTerminal` | Ouvrir un terminal du projet |
| Space z l | `:AzureLogin` | Exécuter `az login` |
| Space z a | `:AzureAccount` | Afficher le compte Azure actif |
| Space z g | `:AzureGroups` | Lister les groupes de ressources |
| Space z r | `:AzureResources` | Lister les ressources |
| Space z p | `:AzurePowerShell` | Ouvrir PowerShell 7 et importer Az s’il est installé |

Les commandes de compte et de ressources utilisent votre connexion Azure actuelle. `:AzurePowerShell` affiche une commande d’installation si Az est absent. Utilisez `Connect-AzAccount` dans ce terminal pour vous connecter à Azure PowerShell.

Bicep utilise les raccourcis LSP habituels pour les diagnostics, la complétion, la documentation au survol, les définitions, les références, le renommage et les actions de code. Redémarrez Neovim après l’installation de `bicep-ls`. `.bicepparam` utilise le type de fichier des paramètres Bicep. Bicep CLI (`bicep` ou `az bicep`) et le serveur de langage (`bicep-ls`) sont deux outils distincts.

Le LSP Azure Pipelines nécessite un espace de travail contenant `azure-pipelines.yml` ou `azure-pipelines.yaml`. Les schémas Microsoft couvrent aussi les modèles dans `Azure-Pipelines/` et `Pipelines/`. Le YAML général utilise yamlls. Les fichiers Terraform `.tf` et `.tfvars` utilisent terraform-ls ; le formatage nécessite Terraform CLI. Bash s’applique aux scripts détectés comme `sh` ou `bash`.

La détection des projets reconnaît également `bicepconfig.json`, les fichiers de pipeline, `.terraform` et `main.tf`. Le débogage Azure Functions est facultatif et nécessite un adaptateur de débogage .NET et les outils appropriés.

<a id="csv-and-tsv-tables"></a>

## Tableaux CSV et TSV

Ouvrir `.csv` ou `.tsv` active l’affichage aligné de csvview.nvim, avec bordures et en-tête fixe détecté automatiquement. CSV utilise des virgules et TSV des tabulations. Les lignes commençant par `#` ou `//` sont considérées comme des commentaires.

Space c v / `:CsvViewToggle` active ou désactive l’affichage. `:CsvViewEnable`, `:CsvViewDisable` et `:CsvViewInfo` permettent de l’activer, le désactiver ou l’inspecter. Exemple :

```vim
:CsvViewEnable delimiter=; header_lnum=1
```
Vous pouvez modifier le fichier normalement lorsque l’affichage tabulaire est actif. Tab et Shift+Tab conservent leur comportement habituel.

<a id="image-and-pdf-previews"></a>

## Aperçus d’images et de PDF

Ouvrez un fichier pris en charge dans l’explorateur, utilisez `:edit` ou exécutez `:ImagePreview path/to/image.jpg`. Sans argument, `:ImagePreview` utilise le fichier actuel. Utilisez la complétion des noms de fichiers pour les chemins avec espaces ; la commande accepte le chemin complet sans guillemets de shell.

Chaque aperçu s’ouvre dans un **onglet WezTerm** distinct nommé d’après le fichier. Les aperçus précédents restent ouverts. Neovim revient au tampon de code précédent au lieu d’afficher l’image ou le PDF sous forme de texte binaire.

| Format | Affichage |
| --- | --- |
| PNG, JPG/JPEG, GIF | `wezterm imgcat` directement |
| WebP, AVIF, SVG, BMP, TIF/TIFF | Conversion en PNG temporaire avec ImageMagick |
| PDF | Conversion de la première page en PNG temporaire avec ImageMagick |

Neovim doit s’exécuter dans WezTerm, avec `wezterm.exe` dans `PATH` et `WEZTERM_PANE` hérité du terminal. Les formats supplémentaires nécessitent [ImageMagick](https://imagemagick.org/script/download.php#windows). La lecture des PDF peut nécessiter Ghostscript et une politique ImageMagick locale autorisant leur conversion. Les échecs de conversion apparaissent dans les notifications.

`:ImagePreviewClose` ferme le dernier aperçu ; `:ImagePreviewCloseAll` ferme tous ceux créés par ce processus Neovim. Le bouton de fermeture de l’onglet WezTerm ou Ctrl+Shift+W permet d’en fermer un directement. À sa fermeture, Neovim ferme ses panneaux d’aperçu et supprime les fichiers temporaires. L’affichage passe par l’invite de commandes Windows (`cmd.exe`).

<a id="markdown-and-obsidian"></a>

## Markdown et Obsidian

Le rendu Markdown se charge à l’ouverture d’un fichier Markdown. Space m r active ou désactive ce rendu. Les blocs de code et les titres gardent des arrière-plans transparents pour laisser visible le fond d’écran WezTerm.

Obsidian est facultatif et se charge par une commande `:Obsidian` ou ses raccourcis. Le chemin du coffre est choisi dans cet ordre :

1. `vim.g.nvim_obsidian_vault`, défini avant le chargement du plugin.
2. La variable d’environnement `OBSIDIAN_VAULT`.
3. `~/Documents/Obsidian`, résolu pour l’utilisateur actuel.

Indiquez un coffre existant dans une session PowerShell avant de lancer Neovim :

```powershell
$env:OBSIDIAN_VAULT = Join-Path $HOME 'Documents\Obsidian'
nvim
```
Pour un réglage local persistant, utilisez les variables d’environnement utilisateur de Windows ou :

```powershell
[Environment]::SetEnvironmentVariable('OBSIDIAN_VAULT', (Join-Path $HOME 'Documents\Obsidian'), 'User')
```
Redémarrez WezTerm après une modification des variables persistantes. Ces paramètres sont propres à la machine et n’ont pas besoin d’être ajoutés aux fichiers Lua partagés.

| Touches | Action |
| --- | --- |
| Space o q | Changer rapidement de note |
| Space o s | Rechercher dans le coffre |
| Space o n | Créer une note |
| Space o t | Ouvrir la note quotidienne du jour |
| Space o b | Afficher les liens entrants |
| Space o c | Vérifier le coffre et la configuration du plugin |

Exécutez `:Obsidian` une fois pour charger l’intégration, puis ouvrez une note du coffre configuré. La complétion des notes et des étiquettes utilise le serveur de langage intégré du plugin avec Blink. Le rendu Markdown fonctionne aussi hors du coffre.

<a id="wezterm-and-wallpapers"></a>

## WezTerm et fonds d’écran

Les sources des fonds d’écran inclus figurent dans les [crédits des images](nvim/backgrounds/CREDITS.fr.md). Les images de [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) ont été retirées, car la collection de fonds d’écran a été remplacée.

Installez la configuration complémentaire à `$HOME\.wezterm.lua`. WezTerm utilise les couleurs Tokyo Night et affiche un fond d’écran assombri pendant que Neovim est actif. Il rétablit l’apparence normale du terminal lorsque Neovim se ferme ou que l’image sélectionnée est absente. La fenêtre du terminal reste opaque.

| Touches ou commande | Action |
| --- | --- |
| Space u b / `:BackgroundPick` | Choisir une image |
| Space u B / `:BackgroundFolder` | Ouvrir le dossier des images dans l’Explorateur Windows |
| Ctrl+Tab / Ctrl+Shift+Tab | Parcourir les tampons Neovim lorsqu’il est actif, sinon les onglets du terminal |
| Alt+Enter | Activer ou désactiver le plein écran WezTerm |
| Ctrl+Shift+L | Ouvrir le panneau de débogage WezTerm |

Le sélecteur cherche les fichiers PNG, JPG/JPEG, GIF, BMP et WebP dans le dossier des images et ses sous-dossiers. Il utilise fzf-lua s’il est disponible, sinon le sélecteur intégré de Neovim. Les fichiers SVG ne sont pas affichés.

Le dossier par défaut est le répertoire de configuration Neovim suivi de `backgrounds`, normalement `$env:LOCALAPPDATA\nvim\backgrounds`. Une sélection est enregistrée sous forme de chemin relatif, par exemple `Magi/01-Magi-Star.jpg`, dans `selected-background.txt`. Annuler conserve la sélection. WezTerm la vérifie environ une fois par seconde. Les anciennes sélections avec des chemins absolus fonctionnent encore localement. Choisir une autre image enregistre un chemin relatif.

Pour utiliser un dossier personnalisé, définissez la même variable d’environnement avant de lancer WezTerm et Neovim :

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```
Placez-y les images, redémarrez WezTerm et choisissez-en une dans Neovim. Utilisez un répertoire absolu ou un chemin relatif au dossier utilisateur `~/...`. Les deux applications doivent recevoir la même valeur. WezTerm utilise aussi `XDG_CONFIG_HOME` et `NVIM_APPNAME` si vous utilisez ces paramètres Neovim.

<a id="customization-and-privacy"></a>

## Personnalisation et confidentialité

Neovim résout les chemins de configuration, de données et de cache avec `stdpath()`. Affichez leurs emplacements réels dans l’éditeur :

```vim
:lua print(vim.fn.stdpath("config"))
:lua print(vim.fn.stdpath("data"))
:lua print(vim.fn.stdpath("cache"))
```
Utilisez `vim.fn.expand("~/...")`, `vim.fs.joinpath()` et les variables d’environnement pour de nouveaux chemins locaux. La détection de PowerShell utilise `PATH`, `ProgramFiles` et `SystemRoot` ; aucun lecteur ni nom d’utilisateur fixe n’est requis.

Les principaux paramètres sont dans `nvim/lua/config/options.lua`, les raccourcis de l’éditeur dans `nvim/lua/config/keymaps.lua` et les réglages des plugins dans `nvim/lua/plugins/`. L’apparence WezTerm, la luminosité du fond d’écran et les raccourcis du terminal sont définis dans `WezTerminal-Config/.wezterm.lua`. Choisissez une Nerd Font installée localement dans WezTerm pour afficher toutes les icônes.

Choisir un fond d’écran crée un fichier local contenant un chemin d’image relatif. Git ignore les sélections, les journaux, les sessions, les fichiers temporaires de l’éditeur et les sauvegardes locales de validation. Il ignore également `.env`, `.terraform/`, les fichiers d’état et de plan Terraform et les journaux de plantage. Conservez les chemins privés des coffres et les identifiants dans les réglages locaux.

Les règles d’exclusion concernent les fichiers non suivis. Elles ne retirent pas les fichiers déjà suivis par Git et ne filtrent pas une archive ZIP créée manuellement. Vérifiez les fichiers partagés, notamment les archives et sauvegardes pouvant contenir d’anciens chemins privés.

Les noms de fichiers et de projets, les fichiers récents et les chemins des tampons sont visibles dans l’éditeur. Tenez-en compte lorsque vous partagez des captures d’écran ou votre écran.

Git contrôle le nom et l’adresse e-mail associés aux commits. Pour vérifier les identités présentes dans l’historique du dépôt :

```powershell
git log --all --format='%h %an <%ae>'
```
Si vous préférez un pseudonyme public et une adresse GitHub noreply pour les prochains commits, définissez-les pour ce dépôt. Remplacez les deux valeurs d’exemple par les vôtres :

```powershell
git config user.name 'YOUR_PUBLIC_ALIAS'
git config user.email 'YOUR_GITHUB_NOREPLY_EMAIL'
```
Copiez votre adresse noreply réelle depuis les paramètres e-mail de GitHub ; consultez les [instructions GitHub relatives à l’adresse e-mail des commits](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address). Ces paramètres concernent les prochains commits. Les commits existants conservent les coordonnées d’auteur et de committer d’origine, sauf réécriture de l’historique.

<a id="plugin-management"></a>

## Gestion des plugins

Utilisez `:Lazy` pour inspecter l’état des plugins. `:Lazy restore` restaure les versions enregistrées dans `lazy-lock.json`. `:Lazy update` installe des versions plus récentes et peut modifier le fichier de verrouillage. Conservez-le lors du partage de la configuration. Les plugins sans entrée sont installés au premier besoin.

Utilisez `:Mason` pour inspecter les outils de langage, `:MasonUpdate` pour actualiser le registre et `:MasonInstall` pour installer des paquets. Le programme tool-installer de Mason demande aussi automatiquement les formateurs configurés, debugpy et Tree-sitter CLI.

Avec un compilateur disponible, vous pouvez installer explicitement les analyseurs :

```vim
:TSInstall bash bicep csv hcl java json lua markdown markdown_inline powershell python query regex terraform toml tsv vim vimdoc yaml
:TSUpdate
```
`TSInstall` ajoute les analyseurs demandés ; `TSUpdate` met à jour les analyseurs installés après une mise à jour de plugin. Rouvrez le fichier si la coloration n’est pas encore active.

<a id="troubleshooting"></a>

## Dépannage

| Symptôme | Points à vérifier |
| --- | --- |
| La configuration semble inchangée | Affichez `stdpath("config")` ; vérifiez la présence d’un dossier imbriqué `nvim/nvim` et les variables d’environnement. |
| L’installation des plugins échoue | Vérifiez Git, le réseau, `:Lazy` et `:messages`. |
| Le sélecteur ou la recherche échoue | Vérifiez `fzf --version` et `rg --version` dans le terminal qui lance Neovim. |
| Les icônes sont des carrés | Configurez une Nerd Font dans WezTerm. |
| Aucune coloration syntaxique | Exécutez `:checkhealth nvim-treesitter`, vérifiez la CLI et le compilateur, puis `:TSInstall` et rouvrez le fichier. |
| Aucun diagnostic Python | Inspectez BasedPyright/Ruff dans `:Mason` ; redémarrez après l’installation et activez l’environnement du projet. |
| Le LSP PowerShell est désactivé | Installez PowerShell Editor Services, vérifiez `pwsh`/`powershell.exe`, puis redémarrez Neovim. |
| Le serveur Java ne démarre pas | Vérifiez les versions du JDK et de Python, jdtls dans `:Mason` et `:JdtShowLogs` après chargement du plugin. |
| Le raccourci de formatage ne fonctionne pas | Inspectez `:ConformInfo` ; installez le formateur et vérifiez `PATH`. |
| Le débogage échoue | Vérifiez debugpy dans `:Mason`, l’interpréteur de l’application et les messages du REPL de débogage. |
| Obsidian ne trouve pas d’espace de travail | Définissez `OBSIDIAN_VAULT` sur un coffre existant et redémarrez Neovim. |
| Le fond d’écran est absent | Vérifiez `$HOME\.wezterm.lua`, le dossier d’images, le fichier de sélection et `NVIM_BACKGROUND_DIR` dans les deux processus. |
| Ctrl+Tab change les onglets du terminal | Relancez Neovim dans WezTerm ; essayez Space b n/p et vérifiez le chargement de la configuration complémentaire. |
| Le rendu graphique échoue | Essayez `config.front_end = "OpenGL"` dans votre configuration WezTerm locale. |
| Les sessions IA échouent | Vérifiez la CLI dans PATH, choisissez un entier de 1 à 8 et agrandissez le terminal pour plusieurs divisions. |
| Un alias IA avec trait de soulignement échoue dans un script | Utilisez `Codex8`, `Claude8`, `CodexEnd` ou `ClaudeEnd` ; les formes avec traits de soulignement sont interactives. |
| Le LSP Bicep est absent | Vérifiez `bicep-ls` dans PATH et redémarrez ; Bicep CLI seul ne suffit pas. |
| Le formatage Terraform échoue | Vérifiez `terraform version` ; Mason installe séparément le serveur de langage. |
| Les raccourcis Azure échouent | Vérifiez `az version`, la connexion et le compte, ainsi que PowerShell 7/Az pour `AzurePowerShell`. |
| L’aperçu d’image échoue | Exécutez Neovim dans WezTerm, vérifiez `wezterm` dans PATH et inspectez `:messages`. |
| La conversion d’image ou de PDF échoue | Vérifiez `magick -version` ; les PDF peuvent aussi nécessiter Ghostscript et une politique adaptée. |

Si un programme externe manque, Neovim affiche une notification. Utilisez `:messages` ou Space u n pour revoir les notifications manquées.

<a id="validate-the-configuration"></a>

## Validation de la configuration

Depuis le dossier du dépôt dans PowerShell, exécutez les commandes suivantes. Elles n’installent pas de plugins et ne modifient pas votre configuration Neovim active :

```powershell
nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
wezterm --config-file '.\WezTerminal-Config\.wezterm.lua' show-keys
```
La première commande vérifie la syntaxe Lua, les liens de documentation et les raccourcis. Elle teste aussi la gestion des chemins avec des profils Windows d’exemple, la sélection des fonds d’écran, le chargement du débogueur, les paramètres Obsidian, les nouvelles tentatives d’installation des analyseurs, les caches Java, les outils cloud, les sessions IA et les commandes d’aperçu.

Ces vérifications simulent le comportement des plugins. Testez aussi les fonctionnalités interactives dans votre session Neovim habituelle. La seconde commande charge la configuration WezTerm et affiche ses raccourcis clavier.
