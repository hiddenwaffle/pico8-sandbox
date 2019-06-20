pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #76
-- https://www.youtube.com/watch?v=bEyTZ5ZZxZs

function _init()
  cls(1)
  ::ten:: _print(chrs(205.5 + rnd(1))); goto ten
end

-->8

local grid_width = 12
local current_col = 1 -- 1-indexed, for consistency
local current_row = 1 -- 1-indexed, for consistency
local line_height = 10 + 1 -- 5 for char, 1 for space
local char_width = 10 + 1 -- 3 for char, 1 for space

function _print(val)
  local x = (current_col - 1) * char_width
  local y = (current_row - 1) * line_height
  local forward_slash = true
  if val == '/' then
    print_forward_slash(x, y)
  elseif val == '\\' then
    print_backslash(x, y)
  end
  current_col += 1
  if current_col > grid_width then
    current_col = 1
    current_row += 1
  end
  flip()
end

function print_forward_slash(x, y)
  line(x,      y + 10,
       x + 10, y,
       7)
end

function print_backslash(x, y)
  line(x,      y,
       x + 10, y + 10,
       7)
end

function chrs(val)
  if val < 206 then
    return '/'
  else
    return '\\'
  end
end
