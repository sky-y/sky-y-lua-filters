--[[

[For latex writer] Apply \ruby in luatexja-ruby package.
http://mirrors.ibiblio.org/CTAN/macros/luatex/generic/luatexja/doc/luatexja-ruby.pdf

# Synopsis

- From: [親|文|字](おや|も|じ "OPTION"){.ruby}
- To:   \ruby[OPTION]{親|文|字}{おや|も|じ}

- From: [圏点](.kenten)
- To:   \kenten{圏点}

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

-- Is (key,text) already exists in metadata?
-- local function exists_in_metalist(metalist, key, text)
--   for k, v in pairs(metalist) do
--     if k == key and string.find(v[1].text, text, 1, true) then
--       return true
--     end
--   end

--   return false
-- end

-- Set metadata if the same text is not included in key
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

-------------------------------- main

if FORMAT == "latex" then
  -- テンプレート変数とメタデータの競合がややこしいので、いったんオフにしている
  -- function Meta (meta)
  --   set_meta(meta, 'header-includes', '\\usepackage{luatexja-ruby}')
  --   return meta
  -- end

  function link_to_ruby(el)
    -- detect ruby command
    local class_ruby
    if el.classes:includes("ruby", 0) then
      class_ruby = "ruby"
    elseif el.classes:includes("aruby", 0) then
      class_ruby = "aruby"
    end

    if el.classes:includes("ruby", 0) or el.classes:includes("aruby", 0) then
      local span = pandoc.Span('', el.attr)

      local text = pandoc.utils.stringify(el.content)
      local yomi = decodeURI(el.target)
      local option = ""

      -- option from Link title
      if pandoc.text.len(el.title) > 0 then
        option = "[" .. el.title .. "]"
      end

      -- option from attribute: opt
      if el.attributes["opt"] then
        option = "[" .. el.attributes["opt"] .. "]"
      end

      local inlines = {
        -- "\\ruby", option, "{", text, "}{", yomi, "}"
        "\\", class_ruby, option, "{", text, "}{", yomi, "}"
      }

      insert_raw_inlines(span, inlines, "latex")

      return span
    else
      return el
    end
  end

  function span_to_kenten(el)
    if el.classes:includes("kenten", 0) then
      local span = pandoc.Span('', el.attr)

      local text = pandoc.utils.stringify(el.content)

      local inlines = {
        "\\kenten{", text, "}"
      }

      insert_raw_inlines(span, inlines, "latex")
      return span
    else
      return el
    end
  end

  return {
    { Meta = Meta },
    { Link = link_to_ruby,
      Span = span_to_kenten }
  }
end
