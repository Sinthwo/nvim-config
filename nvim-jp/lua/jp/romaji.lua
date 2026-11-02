-- Small, offline kana -> keyboard-style Hepburn converter. It does not infer Kanji
-- readings, translate sentences, or disambiguate は / へ as grammatical particles.
local M = {}
local mapping = {}
local function add(k, r, kat)
  mapping[k] = r
  if kat then mapping[kat] = r end
end
local base = {
  {'あ','ア','a'},{'い','イ','i'},{'う','ウ','u'},{'え','エ','e'},{'お','オ','o'},
  {'か','カ','ka'},{'き','キ','ki'},{'く','ク','ku'},{'け','ケ','ke'},{'こ','コ','ko'},
  {'さ','サ','sa'},{'し','シ','shi'},{'す','ス','su'},{'せ','セ','se'},{'そ','ソ','so'},
  {'た','タ','ta'},{'ち','チ','chi'},{'つ','ツ','tsu'},{'て','テ','te'},{'と','ト','to'},
  {'な','ナ','na'},{'に','ニ','ni'},{'ぬ','ヌ','nu'},{'ね','ネ','ne'},{'の','ノ','no'},
  {'は','ハ','ha'},{'ひ','ヒ','hi'},{'ふ','フ','fu'},{'へ','ヘ','he'},{'ほ','ホ','ho'},
  {'ま','マ','ma'},{'み','ミ','mi'},{'む','ム','mu'},{'め','メ','me'},{'も','モ','mo'},
  {'や','ヤ','ya'},{'ゆ','ユ','yu'},{'よ','ヨ','yo'},
  {'ら','ラ','ra'},{'り','リ','ri'},{'る','ル','ru'},{'れ','レ','re'},{'ろ','ロ','ro'},
  {'わ','ワ','wa'},{'を','ヲ','o'},{'ん','ン','n'},
  {'が','ガ','ga'},{'ぎ','ギ','gi'},{'ぐ','グ','gu'},{'げ','ゲ','ge'},{'ご','ゴ','go'},
  {'ざ','ザ','za'},{'じ','ジ','ji'},{'ず','ズ','zu'},{'ぜ','ゼ','ze'},{'ぞ','ゾ','zo'},
  {'だ','ダ','da'},{'ぢ','ヂ','ji'},{'づ','ヅ','zu'},{'で','デ','de'},{'ど','ド','do'},
  {'ば','バ','ba'},{'び','ビ','bi'},{'ぶ','ブ','bu'},{'べ','ベ','be'},{'ぼ','ボ','bo'},
  {'ぱ','パ','pa'},{'ぴ','ピ','pi'},{'ぷ','プ','pu'},{'ぺ','ペ','pe'},{'ぽ','ポ','po'},
  {'ゔ','ヴ','vu'},
  {'。','。','.'},{'、','、',','},{'！','！','!'},{'？','？','?'},
  {'ぁ','ァ','a'},{'ぃ','ィ','i'},{'ぅ','ゥ','u'},{'ぇ','ェ','e'},{'ぉ','ォ','o'},
  {'ゃ','ャ','ya'},{'ゅ','ュ','yu'},{'ょ','ョ','yo'},
  {'ゎ','ヮ','wa'},{'ゐ','ヰ','wi'},{'ゑ','ヱ','we'},
}
for _,x in ipairs(base) do add(x[1], x[3], x[2]) end
local combination_rows={
  {'き','キ','ky'}, {'ぎ','ギ','gy'}, {'し','シ','sh'}, {'じ','ジ','j'},
  {'ち','チ','ch'}, {'ぢ','ヂ','j'}, {'に','ニ','ny'},
  {'ひ','ヒ','hy'}, {'び','ビ','by'}, {'ぴ','ピ','py'},
  {'み','ミ','my'}, {'り','リ','ry'},
}
local endings={{'ゃ','ャ','a'},{'ゅ','ュ','u'},{'ょ','ョ','o'}}
for _,r in ipairs(combination_rows) do
  for _,e in ipairs(endings) do add(r[1]..e[1],r[3]..e[3],r[2]..e[2]) end
end
-- Common loanword Katakana combinations (not a morphological converter).
for _,r in ipairs({
  {'ティ','ti'},{'ディ','di'},{'トゥ','tu'},{'ドゥ','du'},{'チェ','che'},
  {'シェ','she'},{'ジェ','je'},{'ファ','fa'},{'フィ','fi'},
  {'フェ','fe'},{'フォ','fo'},{'ウィ','wi'},{'ウェ','we'},
  {'ウォ','wo'},{'ヴァ','va'},{'ヴィ','vi'},{'ヴェ','ve'},{'ヴォ','vo'},
}) do mapping[r[1]]=r[2] end

local function chars(str)
  local a={}; local i=1
  while i<=#str do
    local b=str:byte(i)
    local len = b < 128 and 1 or b < 224 and 2 or b < 240 and 3 or 4
    a[#a+1]=str:sub(i,i+len-1);i=i+len
  end
  return a
end
local function roman_at(a,i)
  return mapping[(a[i] or '')..(a[i+1] or '')] or mapping[a[i] or '']
end
function M.convert(str)
  local c=chars(tostring(str or ''))
  local result={};local i=1
  while i<=#c do
    local v=c[i]
    if v=='っ' or v=='ッ' then
      local next_roman=roman_at(c,i+1) or ''
      local consonant=next_roman:sub(1,1)
      if next_roman:sub(1,2)=='ch' then consonant='t' end
      if consonant:match('[bcdfghjklmnpqrstvwxyz]') then
        result[#result+1]=consonant
      else result[#result+1]=v end
    elseif v=='ー' then
      local preceding=table.concat(result):match('([aeiou])$')
      result[#result+1]=preceding or 'ー'
    elseif v=='ん' or v=='ン' then
      local nxt=roman_at(c,i+1) or ''
      result[#result+1] = (nxt:match('^[aeiouy]') and "n'" or 'n')
    else
      local double=mapping[v..(c[i+1] or '')]
      if double then result[#result+1]=double;i=i+1
      else result[#result+1]=mapping[v] or v end
    end
    i=i+1
  end
  return table.concat(result)
end
return M
