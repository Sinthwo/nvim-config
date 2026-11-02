-- Optional, user-confirmed SINGLE-note AnkiConnect integration.
-- No automatic synchronization or deck/model creation.
local M={}
local settings=require("jp.settings")
local dictionary=require("jp.dictionary")
local endpoint="http://127.0.0.1:8765"
local function message(x,level) vim.notify(x,level or vim.log.levels.INFO,{title="Japanese Anki"}) end
local function escape(s)
  return tostring(s or ""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"):gsub('"',"&quot;"):gsub("'","&#39;"):gsub("\n","<br>")
end
local function send(action,params)
  local exe=vim.fn.exepath("curl.exe")
  if exe=="" then exe=vim.fn.exepath("curl") end
  if exe=="" then return nil,"curl is not installed or on PATH" end
  local payload=vim.fn.json_encode({action=action,version=6,params=params or {}})
  local command={exe,"--silent","--show-error","--max-time","6","--noproxy","*","--header","Content-Type: application/json","--data-binary","@-",endpoint}
  local ok,proc=pcall(vim.system,command,{text=true,stdin=payload})
  if not ok then return nil,tostring(proc) end
  local result=proc:wait(8000)
  if not result or result.code~=0 then return nil,"AnkiConnect inaccessible or timed out: "..(result and (result.stderr or "") or "unknown") end
  local decoded_ok,obj=pcall(vim.fn.json_decode,result.stdout or "")
  if not decoded_ok or type(obj)~="table" then return nil,"Invalid AnkiConnect response" end
  if obj.error and obj.error~=vim.NIL then return nil,tostring(obj.error) end
  return obj.result,nil
end
local function pick(items,prompt,then_) vim.ui.select(items,{prompt=prompt},then_) end
function M.setup()
  local version,err=send("version")
  if not version then return message("AnkiConnect unavailable. Open Anki and enable AnkiConnect. "..tostring(err),vim.log.levels.ERROR) end
  local decks,e1=send("deckNames")
  local models,e2=send("modelNames")
  if not decks or not models then return message(tostring(e1 or e2),vim.log.levels.ERROR) end
  if #decks==0 or #models==0 then return message("Create a deck/note type in Anki first",vim.log.levels.WARN) end
  pick(decks,"Choose EXISTING Anki deck",function(deck)
    if not deck then return end
    pick(models,"Choose EXISTING note type",function(model)
      if not model then return end
      local fields,fe=send("modelFieldNames",{modelName=model})
      if not fields or #fields<2 then return message("Need an existing note type with >=2 fields: "..tostring(fe),vim.log.levels.ERROR) end
      pick(fields,"Map Japanese front to field",function(front)
        if not front then return end
        pick(fields,"Map meaning/reading back to field",function(back)
          if not back or back==front then return message("Choose two different fields",vim.log.levels.WARN) end
          local summary="Deck: "..deck.." | Type: "..model.." | Front: "..front.." | Back: "..back
          pick({"Cancel","Enable with this mapping"},summary,function(ok)
            if ok~="Enable with this mapping" then return end
            local s=settings.load()
            s.anki={enabled=true,deck=deck,model=model,front_field=front,back_field=back}
            if settings.save(s) then message("Anki configured. Every card still requires explicit confirmation.") end
          end)
        end)
      end)
    end)
  end)
end
local function input(prompt,callback,default)
  vim.ui.input({prompt=prompt,default=default or ""},function(value) if value==nil then return end; callback(value) end)
end
function M.prepare(selected)
  local s=settings.load()
  if not s.anki.enabled then return message("Anki disabled. Run :JPAnkiSetup first.",vim.log.levels.WARN) end
  -- Revalidate that the chosen deck, model, and field mapping still exist.
  local decks,de=send("deckNames")
  local models,me=send("modelNames")
  local fields,fe=send("modelFieldNames",{modelName=s.anki.model})
  if not decks or not models or not fields then return message(tostring(de or me or fe),vim.log.levels.ERROR) end
  if vim.fn.index(decks,s.anki.deck)<0 or vim.fn.index(models,s.anki.model)<0
    or vim.fn.index(fields,s.anki.front_field)<0 or vim.fn.index(fields,s.anki.back_field)<0 then
    return message("Deck/model/field mapping changed. Run :JPAnkiSetup",vim.log.levels.ERROR)
  end
  pick({"Vocabulary","Kanji","Sentence","Grammar","Hiragana","Katakana"},"Card category (tag only)",function(category)
    if not category then return end
    input("Japanese front: ",function(front)
      if front=="" then return message("Front must not be empty",vim.log.levels.WARN) end
      input("Meaning (verified by YOU): ",function(meaning)
        if meaning=="" then return message("Enter a meaning",vim.log.levels.WARN) end
        input("Reading (optional): ",function(reading)
          input("Example/source (optional): ",function(example)
            local back=meaning..(reading~="" and ("\nReading: "..reading) or "")..(example~="" and ("\nExample/source: "..example) or "")
            local note={deckName=s.anki.deck,modelName=s.anki.model,
              fields={[s.anki.front_field]=escape(front),[s.anki.back_field]=escape(back)},
              tags={"nvim_japanese",category:lower()}}
            local possible,perr=send("canAddNotes",{notes={note}})
            if not possible then return message("Duplicate precheck failed: "..tostring(perr),vim.log.levels.ERROR) end
            if possible[1]~=true then return message("Anki rejected candidate; possible duplicate or invalid fields. Nothing sent.",vim.log.levels.WARN) end
            local preview=table.concat({"ONE CARD - REVIEW BEFORE SENDING:",
              "Deck: "..s.anki.deck,"Note type: "..s.anki.model,
              "Category: "..category,"Field "..s.anki.front_field..": "..front,
              "Field "..s.anki.back_field..": "..back,
              "No other cards will be created."},"\n")
            vim.notify(preview,vim.log.levels.INFO,{title="Anki preview"})
            pick({"Cancel - create nothing","CONFIRM - add ONE note"},"Review preview shown in notification",function(choice)
              if choice~="CONFIRM - add ONE note" then return end
              local result,err=send("addNote",{note=note})
              if err then
                message("Anki response failed/ambiguous. Check Anki manually before retrying: "..err,vim.log.levels.ERROR)
              elseif result and result~=vim.NIL then message("Created one Anki note (ID "..tostring(result)..")")
              else message("No note ID returned. Check Anki manually before retrying.",vim.log.levels.ERROR) end
            end)
          end)
        end)
      end)
    end,selected or "")
  end)
end
function M.status()
  local s=settings.load()
  message(s.anki.enabled and ("Enabled for deck: "..s.anki.deck..", type: "..s.anki.model) or "Disabled. Run :JPAnkiSetup")
end
M._escape=escape
return M
