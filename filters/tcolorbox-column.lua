--[[

[For latex writer] column by tcolorbox

## Before

    ---
    column-prefix: '【コラム】'
    column-tcbset: |
      breakable,
      enhanced,
      parbox=false,
      fonttitle=\bfseries,
      attach boxed title to top left={xshift=3mm, yshift*=-\tcboxedtitleheight/2},
      colbacktitle=black,
    ---

    ::: box
    タイトルのない囲みです。
    :::

    ::: {.box title=タイトル付きの囲み}
    タイトル付きの囲みです。
    :::

    ::: {.column title="何らかの小話"}
    タイトルの頭に `■コラム: ` （または`column-prefix`メタデータで指定された文字列）が付きます。
    :::

    ::: {.column title="何らかの小話" option="colbacktitle=black"}
    オプション付きです。
    :::

## After

    \begin{tcolorbox}

    タイトルのない囲みです。

    \end{tcolorbox}

    \begin{tcolorbox}[title=タイトル付きの囲み,]

    タイトル付きの囲みです。

    \end{tcolorbox}

    \begin{tcolorbox}[title=【コラム】何らかの小話,]

    タイトルの頭に \texttt{■コラム:}
    （または\texttt{column-prefix}メタデータで指定された文字列）が付きます。

    \end{tcolorbox}

    \begin{tcolorbox}[title=【コラム】何らかの小話,colbacktitle=black]

    オプション付きです。

    \end{tcolorbox}

]]

-- for debug
-- local pprint = require("pprint")

-------------------------------- default variables

local default_column_title_prefix = "■コラム:\\ "
local column_title_prefix

-- local tcb_header_includes = [[
-- \usepackage{tcolorbox}
-- \tcbuselibrary{xparse}
-- \tcbuselibrary{skins}
-- \tcbuselibrary{breakable}
-- ]]

local default_tcb_include_before = [[
\tcbset{
  breakable,
  enhanced,
  fonttitle=\bfseries,
  parbox=false,
  attach boxed title to top left={xshift=3mm, yshift*=-\tcboxedtitleheight/2},
  colbacktitle=gray!97,
}
]]

-------------------------------- helper functions

-- remove trailing whitespace from string.
-- http://lua-users.org/wiki/CommonFunctions
local function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

-- Stringify markdown string
local function stringify_from_markdown(to, input)
  local result = pandoc.pipe("pandoc", {"-f", "markdown", "-t", to}, input)
  return rtrim(result)
end

-- detect title prefix
local function title_prefix(el, prefix)
  if el.classes:includes("column", 0) and string.len(prefix) > 0 then
    -- set meta_column_prefix if exists
    -- otherwise set default
    return prefix
  else
    return ""
  end
end

local function get_metalist_for_key(meta, key)
  local metalist

  if meta[key] and meta[key].t == 'MetaList' then
    -- meta[key] is an MetaList
    metalist = meta[key]
  else
    -- meta[key] is other meta information (MetaInlines, MetaString, ...)
    metalist = pandoc.MetaList{meta[key]}
  end

  return metalist
end

-- Is (key,text) already exists in metadata?
local function exists_in_metalist(metalist, key, text)
  for k, v in pairs(metalist) do
    if k == key and string.find(v[1].text, text, 1, true) then
      return true
    end
  end

  return false
end

-- Set metadata if the same text is not included in key
local function set_meta(meta, key, text)
  local metalist = get_metalist_for_key(meta, key)

  if not exists_in_metalist(metalist, key, text) then
    table.insert(metalist, pandoc.MetaBlocks{pandoc.RawBlock('latex', text)})
    meta[key] = metalist
  end

  return meta
end

-- get a metadata with key
local function get_meta_text(meta, key)
  if meta[key] then
    -- mete[key] is a table
    if type(meta[key]) == 'table' then
      
      if meta[key].t == 'MetaInlines' then
        return table.unpack(meta[key]).text
      
      elseif meta[key].t == 'MetaBlocks' then
        local str = ""
        for k, v in pairs(table.unpack(meta[key]).content) do
          if v.text then
            str = str .. v.text .. "\n"
          end
        end        
        return rtrim(str)
      
        -- meta[key] is a MetaList
      elseif meta[key].t == 'MetaList' then
        local str = ""
        for k, v in pairs(meta[key]) do
          str = str .. v[1].text .. "\n"
        end
        return rtrim(str)
      
      else
        -- meta[key].t is not above (can be a map)
        -- NOT IMPLEMENTED
        error("get_meta_text: NOT IMPLEMENTED")
      end

    else
      -- meta[key] is not a table
      return meta[key]
    end
  end

  return nil
end

-------------------------------- main

if FORMAT == "latex" then
  function Meta (meta)
    local meta_column_prefix = get_meta_text(meta, "column-prefix")
    local meta_column_tcbset = get_meta_text(meta, "column-tcbset")

    -- テンプレート変数とメタデータの競合がややこしいので、いったんオフにしている
    -- set_meta(meta, 'header-includes', tcb_header_includes)

    --- column prefix
    column_title_prefix = meta_column_prefix or default_column_title_prefix

    -- tcbset
    local meta_tcbset_full
    if meta_column_tcbset then
      meta_tcbset_full = "\\tcbset{\n" .. meta_column_tcbset .. "\n}"
    end
    
    local include_before = meta_tcbset_full or default_tcb_include_before
    set_meta(meta, 'include-before', include_before)

    return meta
  end

  function Div(el)
    if el.classes:includes("box", 0) or el.classes:includes("column", 0) then
      -- option from attribute: title
      local option_title = ""
      if el.attributes["title"] then
        title_content = stringify_from_markdown("latex", title_prefix(el, column_title_prefix) .. el.attributes["title"])
        option_title = "title=" .. title_content .. ","
      end

      -- option from attribute: option
      local option_other = ""
      if el.attributes["option"] then
        option_other = el.attributes["option"]
      end

      local option = ""
      if string.len(option_title .. option_other) > 0 then
        option = "[" .. option_title .. option_other .. "]"
      end
      
      table.insert(el.content, 1, pandoc.RawBlock("latex", "\\begin{tcolorbox}" .. option)) -- prepend
      table.insert(el.content, pandoc.RawBlock("latex", "\\end{tcolorbox}"))
    end

    return el
  end

  return {
    { Meta = Meta },
    { Div = Div }
  }
end
