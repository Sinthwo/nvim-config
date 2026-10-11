# Configuration Windows des outils cloud, IA et d’image

**Langues :** [English](SETUP-CLOUD-TOOLS.md) | Français | [Deutsch](SETUP-CLOUD-TOOLS.de.md) | [日本語](SETUP-CLOUD-TOOLS.ja.md)

Ce guide explique comment installer les outils facultatifs de cloud, d’IA et d’image utilisés par la configuration. Commencez par le [README d’installation](../README.fr.md), puis consultez le [manuel Windows](../MANUAL.fr.md) pour les commandes et raccourcis courants.

<a id="before-first-launch"></a>

## Avant le premier lancement

Installez les outils principaux indiqués dans le README. Après l’installation d’outils en ligne de commande, ouvrez une nouvelle fenêtre PowerShell ou WezTerm pour que Neovim récupère le `PATH` mis à jour. Ouvrez un fichier source pour lancer l’installation du serveur de langage. Laissez les téléchargements se terminer, redémarrez Neovim et vérifiez `:Lazy`, `:Mason`, `:checkhealth` et `:ConformInfo`.

Vous pouvez aussi installer manuellement les paquets Mason supplémentaires :

```vim
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```
Tree-sitter installe les analyseurs `bicep`, `csv`, `hcl`, `terraform` et `tsv` en plus des analyseurs existants. Neovim retente leur installation lorsque Mason a terminé celle de ses outils. Un compilateur C opérationnel et Tree-sitter CLI sont requis.

<a id="bicep-language-server"></a>

## Serveur de langage Bicep

Installez le SDK .NET requis par le paquet du serveur de langage Bicep, puis l’outil global Microsoft :

```powershell
dotnet --info
dotnet tool install --global Azure.Bicep.LangServer
Get-Command bicep-ls
```
Ces commandes suivent les [instructions officielles du serveur de langage Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#bicep-language-server-net-tool). Neovim trouve la commande installée `bicep-ls` dans `PATH`. Redémarrez Neovim après l’installation. Pour mettre à jour une installation existante, utilisez `dotnet tool update --global Azure.Bicep.LangServer`.

Ouvrez un fichier `.bicep` ou `.bicepparam` et utilisez les raccourcis LSP habituels : `K`, `gd`, `gr`, F2, Space c a et Space c d. Installer Bicep CLI ou exécuter `az bicep` ne suffit pas à installer ce serveur de langage.

<a id="terraform-yaml-azure-pipelines-and-bash"></a>

## Terraform, YAML, Azure Pipelines et Bash

- **Terraform :** Mason installe terraform-ls. Installez Terraform CLI séparément en suivant le [guide HashiCorp](https://developer.hashicorp.com/terraform/install). Vérifiez `terraform version`. Les fichiers `.tf` et `.tfvars` bénéficient de la complétion et des diagnostics ; Space c f les formate avec `terraform fmt`.
- **YAML :** Mason installe yaml-language-server ; Space c f utilise Prettier.
- **Azure Pipelines :** Mason installe le [serveur de langage Azure Pipelines](https://github.com/microsoft/azure-pipelines-language-server) de Microsoft. Il est activé dans les espaces de travail contenant `azure-pipelines.yml` ou `azure-pipelines.yaml`, avec le schéma de pipeline Microsoft. Node.js/npm sont requis.
- **Bash :** Mason installe bash-language-server et shfmt. Space c f formate les scripts shell. Installez séparément un environnement Bash pour exécuter les scripts.

Le tableau complet des langages et les raccourcis sont dans le [manuel](../MANUAL.fr.md#language-support-and-formatting).

<a id="azure-cli"></a>

## Azure CLI

Installez Azure CLI avec Windows Package Manager :

```powershell
winget install --exact --id Microsoft.AzureCLI
```
Redémarrez WezTerm, puis vérifiez `az version`. Cette commande suit le [guide d’installation Windows de Microsoft](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows).

| Commande | Touches | Exécution |
| --- | --- | --- |
| `:AzureTerminal` | Space z t | Terminal à la racine du projet |
| `:AzureLogin` | Space z l | `az login` |
| `:AzureAccount` | Space z a | `az account show -o table` |
| `:AzureGroups` | Space z g | `az group list -o table` |
| `:AzureResources` | Space z r | `az resource list -o table` |

Ces commandes ouvrent un terminal Snacks à la racine du projet. Connectez-vous avec `:AzureLogin`, puis utilisez les commandes de compte, de groupes et de ressources pour consulter votre environnement Azure.

<a id="azure-powershell"></a>

## Azure PowerShell

Utilisez PowerShell 7. En suivant le [guide d’installation Az de Microsoft](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell), installez le module pour votre compte actuel :

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
Get-Module -ListAvailable -Name Az
```
`:AzurePowerShell` ou Space z p ouvre PowerShell 7 et importe Az. Si le module est absent, la commande d’installation s’affiche. Connectez-vous et vérifiez votre contexte :

```powershell
Connect-AzAccount
Get-AzContext
Get-AzResourceGroup
```
La configuration trouve PowerShell via `PATH` et `ProgramFiles`. La prise en charge de PowerShell utilise Editor Services installé par Mason.

<a id="codex-and-claude-workspaces"></a>

## Espaces de travail Codex et Claude

Installez les CLI et connectez-vous en suivant la [documentation officielle de Codex CLI](https://learn.chatgpt.com/docs/codex/cli) et le [guide de configuration Claude Code](https://code.claude.com/docs/en/setup). Vérifiez `codex --version` et `claude --version` avant de lancer Neovim.

`:Codex 1` à `:Codex 8` et `:Claude 1` à `:Claude 8` créent des onglets Neovim contenant uniquement des sessions de terminal. L’onglet de code d’origine reste ouvert. Utilisez `gt` et `gT` pour changer d’onglet et appuyez deux fois sur Esc pour quitter la saisie du terminal. `:CodexEnd` / `:ClaudeEnd` ferment les onglets de travail correspondants.

Les alias interactifs comme `:Codex_8`, `:Claude_8`, `:Codex_End` et `:Claude_End` sont pris en charge. Dans les scripts, utilisez des commandes valides sans traits de soulignement. Consultez le [manuel](../MANUAL.fr.md#ai-session-workspaces) pour la disposition et la navigation.

<a id="csv-and-tsv"></a>

## CSV et TSV

csvview.nvim active un affichage tabulaire aligné à l’ouverture d’un fichier CSV/TSV. Space c v le bascule ; `:CsvViewInfo` indique le séparateur et l’en-tête. Tab et Shift+Tab conservent leur comportement. Consultez le [manuel](../MANUAL.fr.md#csv-and-tsv-tables) et la [documentation du plugin](https://github.com/hat0uma/csvview.nvim).

<a id="images-and-pdf-files"></a>

## Images et fichiers PDF

Les images et PDF s’ouvrent dans des onglets WezTerm distincts avec **`wezterm imgcat`**. PNG, JPG/JPEG et GIF s’ouvrent directement. WebP, AVIF, SVG, BMP, TIFF et PDF nécessitent [ImageMagick pour Windows](https://imagemagick.org/script/download.php#windows). Vérifiez le convertisseur avec `magick -version`. Les aperçus PDF affichent la première page et peuvent aussi nécessiter Ghostscript et une politique ImageMagick autorisant la lecture des PDF.

Exécutez Neovim dans WezTerm avec `wezterm.exe` dans `PATH`. Ouvrir une image ou un PDF pris en charge dans l’explorateur crée un aperçu, puis vous ramène au code. Vous pouvez aussi utiliser `:ImagePreview path/to/image.jpg`, `:ImagePreviewClose` et `:ImagePreviewCloseAll`. Les aperçus précédents restent ouverts jusqu’à leur fermeture. Neovim nettoie ses onglets d’aperçu et fichiers temporaires à sa fermeture. Consultez le [manuel](../MANUAL.fr.md#image-and-pdf-previews) et la [référence WezTerm imgcat](https://wezterm.org/cli/imgcat.html).

<a id="wallpapers-and-local-settings"></a>

## Fonds d’écran et paramètres locaux

Le sélecteur parcourt le dossier des images et ses sous-dossiers, puis enregistre votre choix sous forme de chemin relatif. Neovim et WezTerm utilisent `NVIM_BACKGROUND_DIR` lorsqu’il est défini. Annuler conserve le choix précédent ; une image absente rétablit l’apparence normale du terminal. Consultez le [manuel](../MANUAL.fr.md#wezterm-and-wallpapers) pour configurer un dossier personnalisé et les [crédits des fonds d’écran](backgrounds/CREDITS.fr.md) pour les sources.

Conservez les chemins privés dans des variables d’environnement locales telles que `OBSIDIAN_VAULT`. Git ignore les sélections de fonds d’écran, les journaux, les fichiers `.env`, les fichiers d’état et de plan Terraform et les sauvegardes locales de validation. Vérifiez les archives créées manuellement avant de les partager : les règles d’exclusion Git n’en filtrent pas le contenu.

<a id="optional-azure-functions-debugging"></a>

## Débogage facultatif d’Azure Functions

Le débogueur inclus prend en charge Python. Pour ajouter le débogage d’Azure Functions .NET en processus isolé, configurez un adaptateur .NET adapté et installez les outils nécessaires, notamment Azure Functions Core Tools, un SDK .NET et netcoredbg. `azfunc.nvim` est un plugin facultatif pour ce flux de travail.
