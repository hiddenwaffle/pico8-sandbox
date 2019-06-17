pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #1
-- https://www.youtube.com/watch?v=17WoOqgXsRM

g = { }

function _init()
  camera(-64, -64)
  g.stars = { }
  for i = 1, 400 do
    g.stars[i] = star_new()
  end
  g.warp = false
end

function _update60()
  g.warp = btn(5)
  for star in all(g.stars) do
    star_update(star)
  end
end

function _draw()
  cls()
  for star in all(g.stars) do
    star_show(star)
  end
  if not g.warp then
    print('press x to warp', 4 - 64, 4 - 64, 11)
  end
end

-->8

function star_new()
  local star = { }
  star_reset(star)
  return star
end

function star_reset(star)
  star.x = flr(rnd(128)) - 64
  star.y = flr(rnd(128)) - 64
  star.z = flr(rnd(128))
  star.pz = star.z
end

function star_update(star)
  local speed
  if g.warp then
    speed = 5
  else
    speed = 2
  end
  star.pz = star.z
  star.z -= speed
  -- reset it back in place
  if star.z < 1 then
    star_reset(star)
  end
end

function star_show(star)
  -- project it
  local sx = (star.x / star.z) * 128
  local sy = (star.y / star.z) * 128
  -- brightness by distance
  local color
  if star.z > 112 then
    color = 5
  elseif star.z > 80 then
    color = 6
  else
    color = 7
  end
  -- draw it
  if g.warp then
    local spx = (star.x / star.pz) * 128
    local spy = (star.y / star.pz) * 128
    line(sx, sy, spx, spy, color)
  else
    pset(sx, sy, color)
  end
end
