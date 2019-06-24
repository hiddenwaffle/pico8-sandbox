pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/math.p8:0

function _init()
  cls(1)
  x = 0
  y = 0
end

function _update60()
end

function _draw()
  for i = 1, 10 do
    next_point()
    draw_point()
  end
  print('██████', 4, 4, 1) -- :D
  print(stat(1), 4, 4, 7)
end

function next_point()
  local next_x
  local next_y
  local next = rnd(1)
  if next < 0.01 then
    next_x = 0
    next_y = 0.16 * y
  elseif next < 0.86 then
    next_x =  0.85 * x +  0.04 * y
    next_y = -0.04 * x +  0.85 * y + 1.6
  elseif next < 0.93 then
    next_x =  0.20 * x + -0.26 * y
    next_y =  0.23 * x +  0.22 * y + 1.6
  else
    next_x = -0.15 * x +  0.28 * y
    next_y =  0.26 * x +  0.24 * y + 0.44
  end
  x = next_x
  y = next_y
end

function draw_point()
  local px = math_map(x, -2.1820, 2.6558, 0, 128)
  local py = math_map(y, 0, 9.9983, 128, 0)
  local current = pget(px, py)
  if current == 3 then
    pset(px, py, 11)
  else
    pset(px, py, 3)
  end
end
