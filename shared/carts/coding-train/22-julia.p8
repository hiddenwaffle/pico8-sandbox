pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- change constants with arrow keys

-- this is mostly the same as mandelbrot-2.p8 but with a specific constant
-- from the julia wikipedia page
-- coding challenge #22
-- https://www.youtube.com/watch?v=fAsaSkmbF5s

#include lib/math.p8:0

g = { }

function _init()
  cls()
  g.min_slider = -2
  g.max_slider = 2
  g.target_a = 0
  g.target_b = 0.8
end

function _update60()
  if (btn(0)) g.target_a -= 0.1
  if (btn(1)) g.target_a += 0.1
  if (btn(2)) g.target_b -= 0.1
  if (btn(3)) g.target_b += 0.1
end

function _draw()
  local max_iterations = 50 -- todo: should be higher but pico-8 cpu gets maxed out
  for x = 0, 127 do
    for y = 0, 127 do
      local a = map_project(x, 0, 127, g.min_slider, g.max_slider)
      local b = map_project(y, 0, 127, g.min_slider, g.max_slider)
      local n = 0
      while n < max_iterations do
        local aa = a * a - b * b
        local bb = 2 * a * b
        a = aa + g.target_a
        b = bb + g.target_b
        if abs(a + b) > 4 then
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
  print(g.target_a .. ', ' .. g.target_b, 4, 4, 7)
end
