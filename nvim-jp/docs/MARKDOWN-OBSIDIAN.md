# Japanese Markdown and Obsidian on Windows

Install this profile using the [profile guide](../../NeovimProfiles/README.md).
Use Neovim 0.12+ for the pinned Tree-sitter plugins. Run `:Lazy restore`, then
`:JPMarkdownParsers`; parser installation needs Tree-sitter CLI 0.26.1+, `curl`,
`tar`, and a C compiler in PATH. Reopen a Markdown note when installation ends.

Run `:JPSetup` to select and confirm an existing vault containing `.obsidian`.
Restart the Japanese profile afterward. Its `jp-settings.json` stores the
local vault path and optional Anki settings; the coding profile's
`OBSIDIAN_VAULT` is independent.

| Command or keys | Action |
| --- | --- |
| `:JPMarkdownToggle` / Space j R | Toggle Markdown decoration |
| `:JPMarkdownStatus` | Inspect renderer, parser, and verified vault |
| `:JPMarkdownParsers` | Install the four Markdown-related parsers |
| `:Obsidian quick_switch` | Find an existing vault note |
| `:Obsidian search` | Search vault text (requires `rg`) |
| `:Obsidian backlinks` / `:Obsidian toc` | Inspect backlinks or headings |
| `:Obsidian follow_link` | Follow the link under the cursor |

The renderer decorates Markdown in Normal and Command modes, and shows raw
text in Insert mode. Decoration also works outside the vault. It does not
render Mermaid diagrams or embedded graphics. The browser preview mapped to
Space m p belongs to the coding profile.

Obsidian navigation requires a verified vault. Frontmatter updates and the
plugin's daily-note creator are disabled here so the Japanese templates and
`:JPToday` remain in control. `:JPComplete` changes the current buffer; review
it and use `:w` to save.

If decorations are missing, open a `.md` file, run `:JPMarkdownStatus`, check
`:Lazy` and `:checkhealth nvim-treesitter`, and ensure the compiler and CLI
are in PATH. If vault commands are unavailable, run `:JPSetup` and restart.
Use `:JPHelp` for the [complete Japanese reference](../JP-HELP.md).
