pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #4
-- https://www.youtube.com/watch?v=KkyIDI6rQJI

g = { }

function _init()
  g.d = { }
  for i = 1, 100 do
    g.d[i] = drop_new()
  end
end

function _update60()
  for d in all(g.d) do
    drop_fall(d)
  end
end

function _draw()
  cls(1)
  for d in all(g.d) do
    drop_show(d)
  end
end

-->8

function drop_new()
  local drop = { }
  drop_reset(drop)
  return drop
end

function drop_fall(drop)
  drop.y += drop.yspeed
  local grav = (drop.z / 20) * 0.05
  drop.yspeed += grav
  if drop.y > 128 then
    drop_reset(drop)
  end
end

function drop_show(drop)
  line(drop.x, drop.y, drop.x, drop.y + drop.len, 13)
end

function drop_reset(drop)
  drop.x = flr(rnd(128))
  drop.y = flr(rnd(128) - 64)
  drop.z = rnd(20)
  drop.len = flr((drop.z / 20) * 3)
  drop.yspeed = flr((drop.z / 20) * 2) + 1
end
