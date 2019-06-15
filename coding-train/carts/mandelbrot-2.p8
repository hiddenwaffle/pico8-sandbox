pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- zoom with arrow keys

-- coding challenge #21
-- https://www.youtube.com/watch?v=6z7GQewK-Ks

#include lib/math.p8:0

g = { }

function _init()
  cls()
  g.min_slider = -2.5
  g.max_slider = 2.5
end

function _update60()
  if (btn(0)) g.min_slider -= 0.1
  if (btn(1)) g.min_slider += 0.1
  if (btn(2)) g.max_slider += 0.1
  if (btn(3)) g.max_slider -= 0.1
end

function _draw()
  local max_iterations = 50 -- todo: should be higher but pico-8 cpu gets maxed out
  for x = 0, 127 do
    for y = 0, 127 do
      local a = map_project(x, 0, 127, g.min_slider, g.max_slider)
      local b = map_project(y, 0, 127, g.min_slider, g.max_slider)
      local ca = a
      local cb = b
      local n = 0
      while n < max_iterations do
        local aa = a * a - b * b
        local bb = 2 * a * b
        a = aa + ca
        b = bb + cb
        if abs(a + b) > 16 then
          break
        end
        n += 1
      end
      local color
      if n == max_iterations then
        color = 0
      else
        color = flr((n / max_iterations) * 15) + 1
      end
      pset(x, y, color)
    end
  end
end
