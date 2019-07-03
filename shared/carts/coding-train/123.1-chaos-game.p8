pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
  cls(1)
  g.ax = 64
  g.ay = 0
  g.bx = 0
  g.by = 128
  g.cx = 128
  g.cy = 128
  g.x = flr(rnd(128))
  g.y = flr(rnd(128))
  pset(g.ax, g.ay)
  pset(g.bx, g.by)
  pset(g.cx, g.cy)
end

function _update60()
end

function _draw()
  for i = 1, 25 do
    local r = flr(rnd(3))
    if r == 0 then
      color(8)
      g.x = lerp(g.x, g.ax, 0.5)
      g.y = lerp(g.y, g.ay, 0.5)
    elseif r == 1 then
      color(11)
      g.x = lerp(g.x, g.bx, 0.5)
      g.y = lerp(g.y, g.by, 0.5)
    elseif r == 2 then
      color(12)
      g.x = lerp(g.x, g.cx, 0.5)
      g.y = lerp(g.y, g.cy, 0.5)
    end
    pset(g.x, g.y)
  end
end

function lerp(a, b, amt)
  return a + (b - a) * amt
end
