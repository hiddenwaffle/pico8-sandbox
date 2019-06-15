pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- note: pico-8 sgn() 0 = 1 instead of 0... not sure it matters...
-- coding challenge #19
-- https://www.youtube.com/watch?v=z86cx2A4_3E

g = { }

function _init()
  camera(-64, -64)
  g.a = 35
  g.b = 35
  g.n = 2
end

function _update60()
  if (btn(0)) g.a -= 0.5
  if (btn(1)) g.a += 0.5
  if (btn(2)) g.b += 0.5
  if (btn(3)) g.b -= 0.5
  if (btn(4)) g.n -= 0.01
  if (btn(5)) g.n += 0.01
end

function _draw()
  cls(1)
  local a = g.a
  local b = g.b
  local n = g.n
  local px
  local py
  for angle = 0.001, 1, 0.016 do
    local na = 2 / n
    local x = abs(cos(angle)) ^ na * a * sgn(cos(angle))
    local y = abs(sin(angle)) ^ na * b * sgn(sin(angle))
    if px and py then
      line(x, y, px, py, 7)
    end
    px = x
    py = y
  end
  print('a: ' .. a, 4 - 64, 4 - 64 +  0, 7)
  print('b: ' .. b, 4 - 64, 4 - 64 +  7, 7)
  print('n: ' .. n, 4 - 64, 4 - 64 + 14, 7)
end
