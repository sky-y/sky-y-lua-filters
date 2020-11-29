--[[
  Utility functions
]]

-- for debug
-- local pprint = require("pprint")

-- returns URI decoded string
-- from: https://gist.github.com/cgwxyz/6053d51e8d7134dd2e30
local function decodeURI(s)
  if(s) then
    s = string.gsub(s, '%%(%x%x)', 
      function (hex) return string.char(tonumber(hex,16)) end )
  end
  return s
end

-- remove trailing whitespace from string.
-- http://lua-users.org/wiki/CommonFunctions
local function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
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

-- Insert list of string (inline text) to an element with format
-- example: inlines = {"\foo{", "bar", "}"} / format = "latex"
local function insert_raw_inlines(el, inlines, format)
  for k, v in pairs(inlines) do
    table.insert(el.content, pandoc.RawInline(format, v))
  end
end

-- Stringify markdown string
local function stringify_from_markdown(to, input)
  local result = pandoc.pipe("pandoc", {"-f", "markdown", "-t", to}, input)
  return rtrim(result)
end

-- get a metadata with key
local function get_meta_text(meta, key)
  if meta[key] then
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

return {
  decodeURI = decodeURI,
  set_meta = set_meta,
  insert_raw_inlines = insert_raw_inlines,
  stringify_from_markdown = stringify_from_markdown,
  get_meta_text = get_meta_text,
  rtrim = rtrim,
}
