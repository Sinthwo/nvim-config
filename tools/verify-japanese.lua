-- Run from the repository root with nvim --headless -u NONE -i NONE -n -l tools/verify-japanese.lua
-- Real editor buffers and an isolated fixture vault; no plugin or network access.
local checks = 0
local function check(value, message) assert(value, message); checks = checks + 1 end
local function eq(actual, expected, message)
  check(actual == expected, message .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
end
local root = vim.fs.joinpath(vim.fn.getcwd(), ".validation", "japanese-" .. vim.fn.getpid())
local config, vault = root .. "/config", root .. "/Vault O'Example"
vim.fn.mkdir(config .. "/templates", "p")
vim.fn.mkdir(vault .. "/.obsidian", "p")
for _, file in ipairs(vim.fn.glob("nvim-jp/templates/*.md", false, true)) do
  vim.fn.writefile(vim.fn.readfile(file), config .. "/templates/" .. vim.fs.basename(file))
end
package.path = "./nvim-jp/lua/?.lua;" .. package.path
local original_stdpath, original_system = vim.fn.stdpath, vim.system
local original_input, original_select = vim.ui.input, vim.ui.select
local notifications, requests = {}, 0
vim.fn.stdpath = function(kind)
  if kind == "config" then return config end
  if kind == "data" then return root .. "/data" end
  if kind == "cache" then return root .. "/cache" end
  return original_stdpath(kind)
end
vim.system = function() requests = requests + 1; error("Unexpected external process in Japanese writing checks") end
local original_notify = vim.notify
vim.notify = function(message) notifications[#notifications + 1] = message end
package.loaded["jp.plugins"] = { setup = function() end } -- Optional integration is verified separately below.
dofile("nvim-jp/init.lua")
vim.o.undofile, vim.o.swapfile = false, false
local settings = require("jp.settings")
local paths = require("jp.paths")
local initial = settings.load()
eq(initial.vault, "", "Fresh profile has no personal vault")
eq(initial.anki.enabled, false, "Anki starts disabled")
eq(settings.root(), nil, "Fresh profile requires vault setup")
for _, name in ipairs({ "CON", "con.txt", "PRN", "AUX", "NUL", "COM1.md", "LPT9", "..", "../escape", "..\\escape" }) do
  eq(paths.safe_filename(name), nil, "Reject Windows reserved/traversal filename " .. name)
end
eq(paths.safe_filename("食べる"), "食べる", "Japanese filenames remain intact")
eq(paths.safe_filename(".notes"), ".notes", "Ordinary dot-prefixed filenames work")
check(paths.inside(vault .. "/Japanese/a.md", vault), "Note is inside vault")
check(not paths.inside(vault .. "-other/a.md", vault), "Sibling prefix is outside vault")

local selected = { vault .. "/Japanese", "Confirm vault & Japanese folder" }
vim.ui.input = function(_, callback) callback(vault) end
vim.ui.select = function(items, _, callback)
  local choice = table.remove(selected, 1)
  check(vim.tbl_contains(items, choice), "Setup presents the expected choice")
  callback(choice)
end
vim.cmd("JPSetup")
eq(settings.root(), vault .. "/Japanese", "Setup confirms and creates Japanese folder")
eq(vim.fn.filereadable(config .. "/jp-settings.json"), 1, "Settings stay in isolated config directory")
local templates = require("jp.templates")
for kind, file in pairs(templates.list()) do
  local expanded = templates.expand(kind, { DATE = "2026-11-02", TITLE = "Test", WORD = "食べる" })
  check(expanded and not expanded:find("{{", 1, true), "Template expands: " .. file)
end

vim.cmd("JPToday")
local journal = vim.api.nvim_buf_get_name(0)
check(paths.inside(journal, vault .. "/Japanese/Journal"), "Journal is created inside the configured vault: " .. journal .. " | " .. table.concat(notifications, "; "))
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
local inserted = false
for index, line in ipairs(lines) do
  if line:find("<!-- JP:WRITING:BEGIN -->", 1, true) then
    table.insert(lines, index + 1, "今日は日本語を書きます。")
    inserted = true
    break
  end
end
check(inserted, "Journal has a tracked writing block")
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
local saved_before = table.concat(vim.fn.readfile(journal), "\n")
vim.cmd("JPComplete")
check(vim.bo.modified, "Completion leaves reviewable unsaved changes")
eq(table.concat(vim.fn.readfile(journal), "\n"), saved_before, "Completion does not write the note")
vim.cmd("write")
local saved = table.concat(vim.fn.readfile(journal), "\n")
check(saved:find("status: completed", 1, true), "Completion can be saved explicitly")
vim.cmd("JPToday")
eq(table.concat(vim.fn.readfile(journal), "\n"), saved, "Reopening journal never overwrites an existing note")
vim.api.nvim_buf_set_lines(0, -1, -1, false, { "unsaved text" })
vim.ui.input = function(_, callback) callback("Another note") end
vim.cmd("JPWriting")
eq(vim.api.nvim_buf_get_name(0), journal, "Unsaved writing blocks navigation to a new note")
eq(#vim.fn.globpath(vault .. "/Japanese", "Writing/*.md", false, true), 0, "Blocked navigation creates no new file")
vim.cmd("edit!")
require("jp.anki").prepare()
eq(requests, 0, "Writing, setup, and disabled Anki make no external requests")

-- Inspect the real optional plugin specifications without invoking lazy or Git.
local specs, lazy_opts
package.loaded["jp.plugins"] = nil
package.loaded.lazy = { setup = function(value, opts) specs, lazy_opts = value, opts end }
vim.fn.mkdir(root .. "/data/lazy/lazy.nvim", "p")
require("jp.plugins").setup()
eq(lazy_opts.root, root .. "/data/lazy", "Japanese plugin packages use isolated data")
eq(lazy_opts.lockfile, config .. "/lazy-lock.json", "Japanese profile uses its own lockfile")
for _, spec in ipairs(specs) do
  if spec[1] == "obsidian-nvim/obsidian.nvim" then
    check(spec.cond(), "Verified vault enables optional Obsidian")
    local opts = spec.opts()
    eq(opts.frontmatter.enabled, false, "Obsidian preserves template frontmatter")
    eq(opts.daily_notes.enabled, false, "Japanese journal remains in control")
    eq(opts.workspaces[1].path, vim.fs.normalize(vault), "Obsidian uses the verified vault")
  end
end
eq(requests, 0, "Specification checks never download plugins")
vim.fn.stdpath, vim.system = original_stdpath, original_system
vim.ui.input, vim.ui.select, vim.notify = original_input, original_select, original_notify
print(string.format("PASS: %d Japanese profile checks (setup, templates, note preservation, and plugin isolation)", checks))
