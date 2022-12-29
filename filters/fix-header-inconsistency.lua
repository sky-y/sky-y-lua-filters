--[[ 
  [For Sphinx reStructuredText] Fix inconsistency of headers

  # Synopsis

  ## Before

  ```
  # first level
  ## second level
  ## second level
  #### should be third level
  ## second level
  ### third level
  #### should be fourth level
  ```

  ## after (empty lines are removed)

  ```
  # first level
  ## second level
  ## second level
  ### should be third level
  ## second level
  ### third level
  #### should be fourth level
  ```

 ]]

-- for debug using [wlupton/pandoc-lua-logging](https://github.com/wlupton/pandoc-lua-logging)
-- local logging = require 'logging'

local prev_level = 1
local current_level = 1

function Header(el)
  if el.level > prev_level then
    current_level = current_level + 1
  elseif el.level < current_level then
    current_level = el.level
  end

  prev_level = el.level
  el.level = current_level

  return el
end
