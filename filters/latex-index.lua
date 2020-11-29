--[[

[For latex writer] Apply \index of (up)mendex.

# Synopsis

## Before

    [Pandoc]{.index}
    [免疫](めんえき){.index}
    [LaTeX]{.index .only}
    [変数](へんすう){.index .only}
    [Markdown]{.keyword}
    [技術書典](ぎじゅつしょてん){.keyword}
    [--atx-headers]{.index .code}

## After

    {Pandoc\index{Pandoc}}
    {免疫\index{めんえき@免疫}}
    {\index{LaTeX}}
    {\index{へんすう@変数}}
    {\textbf{Markdown}\index{Markdown}}
    {\textbf{技術書典}\index{ぎじゅつしょてん@技術書典}}
    {\texttt{-\/-atx-headers}\index{--atx-headers@\texttt{--atx-headers}}}

## Printing index

    ::: .printindex
    :::

will be `\printindex`.

]]

-- for debug
-- local pprint = require("pprint")

-------------------------------- helper functions

-- local function get_metalist_for_key(meta, key)
--   local metalist

--   if meta[key] and meta[key].t == 'MetaList' then
--     -- meta[key] is an MetaList
--     metalist = meta[key]
--   else
--     -- meta[key] is other meta information (MetaInlines, MetaString, ...)
--     metalist = pandoc.MetaList{meta[key]}
--   end

--   return metalist
-- end

-- -- Is (key,text) already exists in metadata?
-- local function exists_in_metalist(metalist, key, text)
--   for k, v in pairs(metalist) do
--     if k == key and string.find(v[1].text, text, 1, true) then
--       return true
--     end
--   end

--   return false
-- end

-- -- Set metadata if the same text is not included in key
-- local function set_meta(meta, key, text)
--   local metalist = get_metalist_for_key(meta, key)

--   if not exists_in_metalist(metalist, key, text) then
--     table.insert(metalist, pandoc.MetaBlocks{pandoc.RawBlock('latex', text)})
--     meta[key] = metalist
--   end

--   return meta
-- end

-- returns URI decoded string
-- from: https://gist.github.com/cgwxyz/6053d51e8d7134dd2e30
local function decodeURI(s)
  if(s) then
    s = string.gsub(s, '%%(%x%x)', 
      function (hex) return string.char(tonumber(hex,16)) end )
  end
  return s
end

-- Insert list of string (inline text) to an element with format
-- example: inlines = {"\foo{", "bar", "}"} / format = "latex"
local function insert_raw_inlines(el, inlines, format)
  for k, v in pairs(inlines) do
    table.insert(el.content, pandoc.RawInline(format, v))
  end
end

-- replace string for \index{s}
local function escape_for_index_text(s)
  -- escape ! and @ by " (double quote)
  local amp_escaped = string.gsub(s, "([!@])", "\"%1")

  -- escape (, ) and - by \ (backslash)
  -- local backslash_escaped = string.gsub(amp_escaped, "([()])", "\\%1")

  -- replace ' by \textquotesingle{}
  local quote_escaped = string.gsub(amp_escaped, "%’", "\\textquotesingle{}")

  -- replace | by \textbar{}
  local bar_escaped = string.gsub(quote_escaped, "[|]", "\\textbar{}")

  return bar_escaped
end

-------------------------------- main

if FORMAT == "latex" then
  -- テンプレート変数とメタデータの競合がややこしいので、いったんオフにしている
  -- function Meta (meta)
  --   set_meta(meta, 'header-includes', '\\usepackage{makeidx}')
  --   set_meta(meta, 'header-includes', '\\makeindex')
  --   return meta
  -- end

  local function to_index(el)
    if el.classes:includes("index", 0) or el.classes:includes("keyword", 0) then
      local span = pandoc.Span('', el.attr)
      local text = pandoc.utils.stringify(el.content)
      local text_escaped
      local inlines
    
      -- {.index .raw}
      if el.classes:includes("index", 0) and el.classes:includes("raw", 0) then
        text_escaped = text
      else
        text_escaped = escape_for_index_text(text)
      end
    
      -- is Link?
      if el.target then
        local index =  decodeURI(el.target)
        inlines = {
          "\\index{", index, "@", text_escaped, "}"
        }
      elseif el.classes:includes("index", 0) and el.classes:includes("code", 0) then
        inlines = {
          "\\index{", text_escaped, '@\\texttt{', text_escaped, "}}"
        }
      else
        inlines = {
          "\\index{", text_escaped, "}"
        }
      end
    
      -- prepend text
      if el.classes:includes("keyword", 0) then
        -- {.keyword}
        table.insert(span.content, 1, pandoc.Strong(text))
      elseif el.classes:includes("index", 0) then
        if el.classes:includes("only", 0) or el.classes:includes("raw", 0) then
          -- {.index .only} or {.index .raw}
          -- do nothing
        elseif el.classes:includes("code", 0) then
          -- {.index .code}
          table.insert(span.content, 1, pandoc.Code(text))
        else
          -- {.index}
          table.insert(span.content, 1, pandoc.Str(text))
        end
      end

      insert_raw_inlines(span, inlines, "latex")
    
      return span
    end

    return el
  end
  
  function div_to_printindex(el)
    if el.classes:includes("printindex", 0) then
      table.insert(el.content, pandoc.RawBlock("latex", "\\phantomsection"))
      table.insert(el.content, pandoc.RawBlock("latex", "\\addcontentsline{toc}{chapter}{\\indexname}"))
      table.insert(el.content, pandoc.RawBlock("latex", "\\printindex"))
    end
    return el
  end

  return {
    { Meta = Meta },
    {
      Span = to_index,
      Link = to_index,
      Div  = div_to_printindex,
    }
  }
end
