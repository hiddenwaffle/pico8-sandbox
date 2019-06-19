pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #55
-- https://www.youtube.com/watch?v=f5QBExMNB1I

g = { }

function _init()
  camera(-64, -64)
  -- some nice ones are: 5/8, 4/1
  g.k_n = 5
  g.k_d = 8
end

function _update60()
  if btn(0) then
    g.k_n -= 0.02
  end
  if btn(1) then
    g.k_n += 0.02
  end
  if btn(2) then
    g.k_d += 0.02
  end
  if btn(3) then
    g.k_d -= 0.02
  end
end

function _draw()
  local k = g.k_n / g.k_d
  cls(1)
  for a = 0, g.k_d, 0.001 do
    local r = 50 * cos(g.k_d / g.k_n * a)
    local x = r * cos(a)
    local y = r * sin(a)
    pset(x, y, 7)
  end
  print('k_n = ' .. g.k_n, 4 - 64, 4 - 64 + 0, 11)
  print('k_d = ' .. g.k_d, 4 - 64, 4 - 64 + 7, 11)
  print('arrow keys', 84 - 64, 4 - 64, 12)
end
