-- Run from the repository root: nvim --headless -u NONE -i NONE -n -l tools/verify-docs.lua
-- Reads documentation only; no plugins, downloads, or active config changes.
local checks = 0
local function check(value, message)
  if not value then
    io.stderr:write("FAIL: " .. message .. "\n")
    vim.cmd("cquit 1")
  end
  checks = checks + 1
end

local function read(path)
  return table.concat(vim.fn.readfile(path), "\n")
end

check(vim.fn.filereadable("README.md") == 1 and vim.fn.filereadable("MANUAL.md") == 1,
  "Run this command from the repository root.")

local function slug(heading)
  return vim.fn.tolower(heading):gsub("%p", function(char)
    return (char == "-" or char == "_") and char or ""
  end):gsub("’", ""):gsub("・", ""):gsub("%s", "-")
end

local function parse(text, path)
  local result = { anchors = {}, outline = {}, tables = {}, shortcuts = {}, blocks = {}, images = {} }
  local fence, block, language, table_rows, table_columns
  local function finish_table()
    if table_rows then
      table.insert(result.tables, { rows = table_rows, columns = table_columns })
      table_rows, table_columns = nil, nil
    end
  end
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    local marker, info = line:match("^%s*(```+)(.*)$")
    if not marker then marker, info = line:match("^%s*(~~~+)(.*)$") end
    if fence then
      if marker == fence and vim.trim(info) == "" then
        table.insert(result.blocks, { language = language, text = table.concat(block, "\n") })
        fence, block, language = nil, nil, nil
      else
        table.insert(block, line)
      end
    elseif marker then
      finish_table()
      fence, block, language = marker, {}, vim.trim(info)
    else
      local level, heading = line:match("^(#+) (.+)$")
      if heading then
        result.anchors[slug(heading)] = true
        if heading == "Images and sources" then
          result.translation_tables = vim.deepcopy(result.tables)
        end
        -- The English wallpaper guide additionally owns the shared image catalog.
        if #level >= 2 and heading ~= "Images and sources" then
          table.insert(result.outline, #level)
        end
      end
      if line:match("^|.*|%s*$") then
        if not line:match("^|[%s:|%-]+|%s*$") then
          local _, pipes = line:gsub("|", "")
          local columns = pipes - 1
          if table_columns then
            check(columns == table_columns, path .. ": inconsistent table columns: " .. line)
          end
          table_rows, table_columns = (table_rows or 0) + 1, columns
        end
      else
        finish_table()
      end
      for code in line:gmatch("`([^`]+)`") do
        if code == "Space" or code:match("^Space%s") or code:match("^Ctrl")
          or code:match("^F%d") or code:match("^Win%+") or code:match("^:[A-Z]") then
          result.shortcuts[code] = true
        end
      end
      local image = line:match("^| %[%!%[.-%]%(([^%)]+%.png)%)")
      if image and path:match("^docs/screenshots/README") then
        check(not result.images[image], path .. ": duplicate gallery image " .. image)
        local action, target = line:match("| `([^`]+)` · %[[^%]]+%]%(([^%)]+)%) |%s*$")
        check(action and target, path .. ": screenshot needs an action and guide: " .. image)
        result.images[image] = action
      end
    end
  end
  finish_table()
  check(not fence, path .. ": unclosed code fence")
  return result
end

local documents, parsed = {}, {}
for _, path in ipairs(vim.fn.glob("**/*.md", false, true)) do
  path = path:gsub("\\", "/")
  if not path:match("^%.validation/") and not path:match("^%.git/") then
    documents[#documents + 1] = path
    parsed[path] = parse(read(path), path)
  end
end

for _, path in ipairs(documents) do
  local text = read(path)
  for target in text:gmatch("%]%(([^%)]+)%)") do
    target = target:gsub("^<", ""):gsub(">$", "")
    if not target:match("^[%a][%w+.-]*:") then
      local name, anchor = target:match("^([^#]*)#?(.*)$")
      name = name:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
      local destination = name == "" and path or vim.fs.normalize(vim.fs.joinpath(vim.fs.dirname(path) or ".", name))
      check(vim.uv.fs_stat(destination), path .. ": missing local target " .. target)
      if anchor ~= "" then
        anchor = anchor:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
        local doc = parsed[destination] or parse(read(destination), destination)
        check(doc.anchors[anchor], path .. ": missing heading " .. target)
      end
    end
  end
end

local function equal_set(source, translation, path, label)
  for value in pairs(source) do
    check(translation[value] ~= nil, path .. ": missing " .. label .. " " .. value)
  end
  for value in pairs(translation) do
    check(source[value] ~= nil, path .. ": extra " .. label .. " " .. value)
  end
end

for _, stem in ipairs({ "README", "MANUAL", "nvim/SETUP-CLOUD-TOOLS", "nvim/backgrounds/README", "docs/screenshots/README", "nvim/backgrounds/CREDITS" }) do
  local source = parsed[stem .. ".md"]
  check(source, "Missing English source " .. stem .. ".md")
  for _, locale in ipairs({ ".de", ".fr", ".ja" }) do
    local path = stem .. locale .. ".md"
    local translation = parsed[path]
    check(translation, "Missing translation " .. path)
    check(vim.deep_equal(source.outline, translation.outline), path .. ": heading coverage differs from English")
    check(vim.deep_equal(source.translation_tables or source.tables, translation.tables), path .. ": table coverage differs from English")
    check(vim.deep_equal(source.blocks, translation.blocks), path .. ": code examples differ from English")
    equal_set(source.shortcuts, translation.shortcuts, path, "shortcut/command")
    equal_set(source.images, translation.images, path, "gallery image")
    for image, action in pairs(source.images) do
      check(translation.images[image] == action, path .. ": different screenshot action for " .. image)
    end
  end
end

local gallery = parsed["docs/screenshots/README.md"].images
for _, image in ipairs(vim.fn.glob("docs/screenshots/*.png", false, true)) do
  check(gallery[vim.fs.basename(image)], "Gallery is missing " .. image)
end

-- English-only destinations must be clearly labelled in translated pages.
for _, path in ipairs(documents) do
  if path:match("%.de%.md$") or path:match("%.fr%.md$") or path:match("%.ja%.md$") then
    for label, target in read(path):gmatch("%[([^%]]+)%]%(([^%)]+)%)") do
      if target:find("NeovimProfiles/README.md", 1, true) or target:find("nvim-jp/JP-HELP.md", 1, true) then
        check(label:find("Englisch", 1, true) or label:find("anglais", 1, true) or label:find("英語", 1, true),
          path .. ": label this English-only link: " .. target)
      end
    end
  end
end

print(string.format("PASS: %d documentation checks across %d Markdown files (links, translation coverage, shortcuts, code examples, and galleries)", checks, #documents))
