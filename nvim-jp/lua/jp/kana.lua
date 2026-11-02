-- Zero-dependency recognition trainer; romanized responses only.
-- Japanese IME remains the user's normal system for composing actual Japanese.
local M={}
local log=require('jp.study_log')
local groups={
  { 'あ','a','ア' },{ 'い','i','イ' },{ 'う','u','ウ' },{ 'え','e','エ' },{ 'お','o','オ' },
  { 'か','ka','カ' },{ 'き','ki','キ' },{ 'く','ku','ク' },{ 'け','ke','ケ' },{ 'こ','ko','コ' },
  { 'さ','sa','サ' },{ 'し','shi','シ' },{ 'す','su','ス' },{ 'せ','se','セ' },{ 'そ','so','ソ' },
  { 'た','ta','タ' },{ 'ち','chi','チ' },{ 'つ','tsu','ツ' },{ 'て','te','テ' },{ 'と','to','ト' },
  { 'な','na','ナ' },{ 'に','ni','ニ' },{ 'ぬ','nu','ヌ' },{ 'ね','ne','ネ' },{ 'の','no','ノ' },
  { 'は','ha','ハ' },{ 'ひ','hi','ヒ' },{ 'ふ','fu','フ' },{ 'へ','he','ヘ' },{ 'ほ','ho','ホ' },
  { 'ま','ma','マ' },{ 'み','mi','ミ' },{ 'む','mu','ム' },{ 'め','me','メ' },{ 'も','mo','モ' },
  { 'や','ya','ヤ' },{ 'ゆ','yu','ユ' },{ 'よ','yo','ヨ' },
  { 'ら','ra','ラ' },{ 'り','ri','リ' },{ 'る','ru','ル' },{ 'れ','re','レ' },{ 'ろ','ro','ロ' },
  { 'わ','wa','ワ' },{ 'を','wo','ヲ' },{ 'ん','n','ン' },
}
M.data=groups

local voiced={
  {'が','ga','ガ'},{'ぎ','gi','ギ'},{'ぐ','gu','グ'},{'げ','ge','ゲ'},{'ご','go','ゴ'},
  {'ざ','za','ザ'},{'じ','ji','ジ'},{'ず','zu','ズ'},{'ぜ','ze','ゼ'},{'ぞ','zo','ゾ'},
  {'だ','da','ダ'},{'ぢ','ji','ヂ'},{'づ','zu','ヅ'},{'で','de','デ'},{'ど','do','ド'},
  {'ば','ba','バ'},{'び','bi','ビ'},{'ぶ','bu','ブ'},{'べ','be','ベ'},{'ぼ','bo','ボ'},
  {'ぱ','pa','パ'},{'ぴ','pi','ピ'},{'ぷ','pu','プ'},{'ぺ','pe','ペ'},{'ぽ','po','ポ'},
}
local combinations={}
for _,row in ipairs({
  {'き','キ','ky'}, {'ぎ','ギ','gy'}, {'し','シ','sh'}, {'じ','ジ','j'},
  {'ち','チ','ch'}, {'に','ニ','ny'}, {'ひ','ヒ','hy'}, {'び','ビ','by'},
  {'ぴ','ピ','py'}, {'み','ミ','my'}, {'り','リ','ry'},
}) do
  for _,endings in ipairs({{'ゃ','ャ','a'},{'ゅ','ュ','u'},{'ょ','ョ','o'}}) do
    combinations[#combinations+1] = {row[1]..endings[1],row[3]..endings[3],row[2]..endings[2]}
  end
end
M.voiced=voiced
M.combinations=combinations

local equivalents={ shi={'si'}, chi={'ti'}, tsu={'tu'}, fu={'hu'}, wo={'o'}, n={'nn'} }
function M.is_correct(index, input)
  local pair=groups[index]
  if not pair then return false end
  local entry=tostring(input or ''):lower():gsub('^%s+',''):gsub('%s+$','')
  if entry==pair[2] then return true end
  for _,alt in ipairs(equivalents[pair[2]] or {}) do
    if entry==alt then return true end
  end
  return false
end
function M.quiz()
  vim.ui.select({'Hiragana / ひらがな','Katakana / カタカナ','Mixed / both'},
    {prompt='Kana recognition script'}, function(mode)
      if not mode then return end
      vim.ui.select({'46 basic Kana', '25 voiced/semi-voiced Kana',
        '33 combined Kana (kya, sha, cha...)', 'All 104 beginner sounds'},
        {prompt='Choose Kana set'}, function(group_choice)
      if not group_choice then return end
      local pool={}
      if group_choice=='46 basic Kana' or group_choice=='All 104 beginner sounds' then
        for _,pair in ipairs(groups) do pool[#pool+1]=pair end
      end
      if group_choice=='25 voiced/semi-voiced Kana' or group_choice=='All 104 beginner sounds' then
        for _,pair in ipairs(voiced) do pool[#pool+1]=pair end
      end
      if group_choice=='33 combined Kana (kya, sha, cha...)' or group_choice=='All 104 beginner sounds' then
        for _,pair in ipairs(combinations) do pool[#pool+1]=pair end
      end
      for i=#pool,2,-1 do
        local j=math.random(i);pool[i],pool[j]=pool[j],pool[i]
      end
      local total=math.min(#pool,15)
      local score=0
      local i=1
      local function next_one()
        if i>total then
          vim.notify('Kana practice finished: '..score..'/'..total..' recognised correctly. No cards scheduled.')
          return
        end
        local pair=pool[i]
        local katakana=mode=='Katakana / カタカナ'
          or (mode=='Mixed / both' and math.random(2)==1)
        local symbol=katakana and pair[3] or pair[1]
        vim.ui.input({prompt='['..i..'/'..total..'] Romaji for '..symbol..' (Esc: stop): '},function(input)
          if input==nil then return end
          local answer=tostring(input or ''):lower():gsub('^%s+',''):gsub('%s+$','')
          local good=answer==pair[2]
          if not good then
            for _,alt in ipairs(equivalents[pair[2]] or {}) do
              if answer==alt then good=true;break end
            end
          end
          log.record('kana_seen')
          if good then score=score+1; log.record('kana_correct') end
          vim.ui.select({'Next', 'Stop'},
            {prompt=(good and 'Correct!' or 'Not quite.')..' '..symbol..' = '..pair[2]},function(choice)
              if choice~='Next' then return end
              i=i+1;vim.schedule(next_one)
            end)
        end)
      end
      next_one()
      end)
    end)
end
return M
