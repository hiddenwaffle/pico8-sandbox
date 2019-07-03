pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- intuition on the heart curve

-- https://www.youtube.com/watch?v=oUBAi9xQ2X4

#include lib/vector2.p8

g = { }

function _init()
  g.heart = { }
  g.a = 0
  cls()
  camera(-64, -64)
end

function _update60()
  local r = 3
  local x = r * 16 * sin(g.a) ^ 3
  local y = -r * (13 * cos(g.a) - 5 * cos(2 * g.a) - 2 * cos(3 * g.a) - cos(4 * g.a))
  add(g.heart, vector2_type:new(x, y))
  g.a += 0.01
end

function _draw()
  local started = false
  for v in all(g.heart) do
    if started then
      line(v.x, v.y) -- will be overwritten next value?
    else
      line(v.x, v.y, v.x, v.y, 14)
      started = true
    end
  end
end
