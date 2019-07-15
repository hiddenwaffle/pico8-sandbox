pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- bookmark: 6:10
-- https://www.youtube.com/watch?v=YNyULRrydVI

#include lib/vector2.p8

width = 128
height = 128
points = { }

function _init()
  for i = 1, 10 do
    add(points, vector2_type:new(flr(rnd() * width), flr(rnd() * height)))
  end
end

function _update60()
end

function _draw()
  cls(1)
  color(7)
  for p in all(points) do
    pset(p.x, p.y)
  end
end
