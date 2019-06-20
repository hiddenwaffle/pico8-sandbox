pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_text_defined_ = true

local __lib_text_font_height = 5
local __lib_text_font_width = 3
local __lib_text_space_width = 1

function text_print_center(val, cx, cy, c)
  if (not val) val = ''
  if (not cx) cx = 0
  if (not cy) cy = 0
  if (not c) c = 0
  local str = tostr(val) -- in case it is not already a string
  local x = cx - flr(text_pixel_width(str)  / 2)
  local y = cy and cy - (__lib_text_font_height - 3)
  print(str, x, y, c)
end

function text_pixel_width(str)
  local char_sum  = #str       * __lib_text_font_width
  local space_sum = (#str - 1) * __lib_text_space_width
  return char_sum + space_sum
end

-->8

function _init()
  test_text_print_center()
end

function test_text_print_center()
  cls(1)
  text_print_center('hello world', 64, 64,      7) -- width: 11 chars (odd)
  text_print_center('hello carl',  64, 64 +  7, 7) -- width: 10 chars (even)
  text_print_center(nil,           64, 64 + 14, 7)
end
