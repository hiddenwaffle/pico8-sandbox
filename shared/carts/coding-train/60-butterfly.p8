pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this is kind of different from the video

-- coding challenge #60
-- https://www.youtube.com/watch?v=O_0fRV4MTZo

#include lib/shape2d.p8:0
#include lib/open-simplex-noise.p8:0

g = { }

function _init()
  camera(-64, -64)
  os2d_noise()
end

function _update60()
end

function _draw()
  cls(1)
  local r = 36
  local points = 100
  local da = 1 / points
  local dx = 0.02
  local xoff = 0
  local points = { }
  local flip_points = { }
  for a = -0.25, 0.25, da do
    r = sin(2 * a) * 40 + os2d_eval(xoff, t()) * 5
    local x = sin(t() / 2) * r * cos(a)
    local y = r * sin(a)
    xoff += dx
    add(points, { x = x, y = y})
    add(flip_points, { x = -x, y = -y})
  end
  shape2d(points, 7, false)
  shape2d(flip_points, 7, false)
end
