# Galerie de captures d’écran Neovim

**Langues :** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

Captures de la configuration Neovim et WezTerm pour Windows, réalisées avec des fichiers d’exemple dans un environnement isolé. Les vues IA montrent seulement la disposition ou la configuration initiale ; la vue de débogage ne montre aucune session active. Aucun déploiement cloud ni opération de compte n’est présenté.

[Retour au README principal](../../README.fr.md)

- [Édition et navigation](#édition-et-navigation)
- [Écriture et données](#écriture-et-données)
- [Git et historique](#git-et-historique)
- [Terminaux et outils](#terminaux-et-outils)
- [Espaces de travail IA](#espaces-de-travail-ia)
- [Profil d’écriture japonaise](#profil-décriture-japonaise)

## Édition et navigation

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![Tableau de bord](dashboard.png)](dashboard.png) | **Tableau de bord** — Logo de requin et raccourcis pour les fichiers, la recherche, les plugins et les terminaux. | `Space u D` · [Guide](../../MANUAL.fr.md#tableau-de-bord-et-notifications) |
| [![Éditeur et explorateur de fichiers](editor-explorer.png)](editor-explorer.png) | **Éditeur et explorateur de fichiers** — Fichier Lua à côté de l’arborescence du projet, avec les fichiers ouverts en haut. | `Ctrl+B` · [Guide](../../MANUAL.fr.md#recherche-de-fichiers-et-explorateur) |
| [![Sélecteur de fichiers](file-picker.png)](file-picker.png) | **Sélecteur de fichiers** — Recherche par nom avec aperçu du fichier sélectionné. | `Space f f` · [Guide](../../MANUAL.fr.md#recherche-de-fichiers-et-explorateur) |
| [![Découverte des raccourcis](shortcuts.png)](shortcuts.png) | **Découverte des raccourcis** — Which-Key regroupe les raccourcis de la touche leader par tâche. | `Space` · [Guide](../../MANUAL.fr.md#édition-et-raccourcis) |
| [![Recherche dans le projet](search.png)](search.png) | **Recherche dans le projet** — Résultats de recherche dans le projet avec aperçu de la ligne sélectionnée. | `Space f g` · [Guide](../../MANUAL.fr.md#recherche-de-fichiers-et-explorateur) |
| [![Recherche des TODO](todo.png)](todo.png) | **Recherche des TODO** — Commentaires TODO avec leur contexte dans le volet d’aperçu. | `Space f t` · [Guide](../../MANUAL.fr.md#recherche-de-fichiers-et-explorateur) |
| [![Notes temporaires](scratch.png)](scratch.png) | **Notes temporaires** — Un bloc-notes flottant garde les notes à côté du code actuel. | `Space u .` · [Guide](../../MANUAL.fr.md#git-et-terminaux-du-projet) |
| [![Historique des notifications](notifications.png)](notifications.png) | **Historique des notifications** — Messages précédents de l’éditeur regroupés dans l’historique. | `Space u n` · [Guide](../../MANUAL.fr.md#tableau-de-bord-et-notifications) |
| [![Mode Zen](zen.png)](zen.png) | **Mode Zen** — Document Markdown centré, avec les panneaux de l’éditeur masqués. | `Space u z` · [Guide](../../MANUAL.fr.md#édition-et-raccourcis) |

## Écriture et données

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![Complétion du code](completion.png)](completion.png) | **Complétion du code** — Suggestions Lua avec documentation de l’élément sélectionné. | `Ctrl+Space` · [Guide](../../MANUAL.fr.md#édition-et-raccourcis) |
| [![Diagnostics du langage](diagnostics.png)](diagnostics.png) | **Diagnostics du langage** — Erreur de type Python affichée dans le code et dans le panneau de diagnostics. | `Space x x` · [Guide](../../MANUAL.fr.md#prise-en-charge-des-langages-et-formatage) |
| [![Rendu Markdown](markdown.png)](markdown.png) | **Rendu Markdown** — Titres, cases à cocher, encadré, code et tableau mis en forme. | `Space m r` · [Guide](../../MANUAL.fr.md#markdown-et-obsidian) |
| [![Tableaux CSV](csv.png)](csv.png) | **Tableaux CSV** — Valeurs CSV alignées en colonnes tout en restant modifiables comme du texte. | `Space c v` · [Guide](../../MANUAL.fr.md#tableaux-csv-et-tsv) |
| [![Notes Obsidian](obsidian.png)](obsidian.png) | **Notes Obsidian** — Sélection rapide de notes d’exemple du coffre avec aperçu. | `Space o q` · [Guide](../../MANUAL.fr.md#markdown-et-obsidian) |
| [![Aperçu d’image](image_preview.png)](image_preview.png) | **Aperçu d’image** — Image affichée dans son propre onglet d’aperçu WezTerm. | `:ImagePreview path/to/image.jpg` · [Guide](../../MANUAL.fr.md#aperçus-dimages-et-de-pdf) |

## Git et historique

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![État Git](git.png)](git.png) | **État Git** — Neogit affiche le fichier modifié et ses changements non indexés. | `Space g g` · [Guide](../../MANUAL.fr.md#git-et-terminaux-du-projet) |
| [![Différence côte à côte](diff.png)](diff.png) | **Différence côte à côte** — Liste des fichiers modifiés à côté d’une comparaison du code côte à côte. | `Space g d` · [Guide](../../MANUAL.fr.md#git-et-terminaux-du-projet) |
| [![Historique des annulations](undo.png)](undo.png) | **Historique des annulations** — Branches de l’historique des annulations à côté du document. | `Space u u` · [Guide](../../MANUAL.fr.md#édition-et-raccourcis) |

## Terminaux et outils

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![Terminal du projet](terminal.png)](terminal.png) | **Terminal du projet** — Terminal du projet sous le code, affichant le contenu d’un dossier. | `Space t t` · [Guide](../../MANUAL.fr.md#git-et-terminaux-du-projet) |
| [![Terminal flottant](floating_terminal.png)](floating_terminal.png) | **Terminal flottant** — Terminal flottant au-dessus de l’éditeur, avec le code toujours visible. | `Space t f` · [Guide](../../MANUAL.fr.md#git-et-terminaux-du-projet) |
| [![Édition des langages cloud](cloud_languages.png)](cloud_languages.png) | **Édition des langages cloud** — Terraform et YAML Azure Pipelines ouverts côte à côte. | `:vsplit azure-pipelines.yml` · [Guide](../../MANUAL.fr.md#azure-et-outils-cloud) |
| [![Gestionnaire de fonds d’écran](wallpapers.png)](wallpapers.png) | **Gestionnaire de fonds d’écran** — Gestionnaire proposant navigation, favoris, sélection aléatoire et réglages de démarrage. | `Space u b` · [Guide](../../nvim/backgrounds/README.fr.md) |
| [![Gestionnaire de plugins](plugins.png)](plugins.png) | **Gestionnaire de plugins** — Lazy affiche les plugins installés et leur état de chargement. | `:Lazy` · [Guide](../../MANUAL.fr.md#gestion-des-plugins) |
| [![Gestionnaire des outils de langage](language_tools.png)](language_tools.png) | **Gestionnaire des outils de langage** — Mason affiche les outils de langage installés et disponibles. | `:Mason` · [Guide](../../MANUAL.fr.md#prise-en-charge-des-langages-et-formatage) |
| [![Panneaux de débogage (aucune session active)](debug.png)](debug.png) | **Panneaux de débogage (aucune session active)** — Panneaux de débogage autour du code Python ; aucune session active. | `F5` · [Guide](../../MANUAL.fr.md#débogage-python) |

## Espaces de travail IA

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![Disposition des sessions Claude (configuration initiale)](claude_sessions.png)](claude_sessions.png) | **Disposition des sessions Claude (configuration initiale)** — Deux terminaux Claude superposés à la configuration initiale ; aucune tâche active. | `:Claude 2` · [Guide](../../MANUAL.fr.md#espaces-de-travail-des-sessions-ia) |
| [![Disposition des sessions Codex (aperçu vide)](codex_sessions.png)](codex_sessions.png) | **Disposition des sessions Codex (aperçu vide)** — Deux terminaux superposés montrent la disposition ; les aperçus sont vides. | `:Codex 2` · [Guide](../../MANUAL.fr.md#espaces-de-travail-des-sessions-ia) |

## Profil d’écriture japonaise

| Aperçu | Fonction | Essai / guide |
| --- | --- | --- |
| [![Tableau de bord d’étude du japonais](japanese_dashboard.png)](japanese_dashboard.png) | **Tableau de bord d’étude du japonais** — Raccourcis d’étude pour le journal, le vocabulaire, les références et la révision. | `:JPDashboard` · [Guide (anglais)](../../nvim-jp/JP-HELP.md#commands) |
| [![Tableau des kana](japanese_kana.png)](japanese_kana.png) | **Tableau des kana** — Hiragana, katakana et romaji alignés dans un tableau de référence. | `:JPKanaChart` · [Guide (anglais)](../../nvim-jp/JP-HELP.md#commands) |
| [![Tableau des kanji](japanese_kanji.png)](japanese_kanji.png) | **Tableau des kanji** — Kanji de première année avec exemples de lecture et sens en anglais. | `:JPKanjiList` · [Guide (anglais)](../../nvim-jp/JP-HELP.md#commands) |
| [![Écriture japonaise](japanese_writing.png)](japanese_writing.png) | **Écriture japonaise** — Exemple d’écriture japonaise avec tableau de vocabulaire et liste de pratique. | `:JPWriting` · [Guide (anglais)](../../nvim-jp/JP-HELP.md#commands) |
