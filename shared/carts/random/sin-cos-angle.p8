pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  g_t = 0
end

function _update60()
  g_t += 0.002
  if (g_t >= 1) g_t = 0
end

function _draw()
  cls()
  local cost = cos(g_t)
  local sint = sin(g_t)
  print('ang ' .. g_t)
  print('cos ' .. cost)
  print('sin ' .. sint)
  circ(64, 64, 48, 1)
  line(64, 0, 64, 128, 7) -- y-axis
  line(0, 64, 128, 64, 7) -- x-axis
  pset(cost * 48 + 64, sint * 48 + 64, 12)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000