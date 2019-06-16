pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #30
-- https://www.youtube.com/watch?v=KWoJgHFYWxY

g = { }

function _init()
  cls(1)
  g.n = 0
  g.c = 2
end

function _update60()
  g.n += 1
end

function _draw()
  local a = g.n * 137.5 -- can use different angles here
  local theta = a / 360
  local r = g.c * sqrt(g.n)
  local x = r * cos(theta) + 64
  local y = r * sin(theta) + 64
  circfill(x, y, 1, color(a))
end

function color(angle)
  return flr(angle) % 15 + 1
end
