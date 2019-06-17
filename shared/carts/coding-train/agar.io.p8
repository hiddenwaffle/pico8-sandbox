pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #32
-- https://www.youtube.com/watch?v=JXuxYMGe4KI

#include lib/vector.p8:0

g = { }

function _init()
  g.mouse = vector_type:new(0, 0)
  g.blob = blob_type:new(0, 0, 8)
  g.blobs = { }
  for i = 1, 50 do
    local x = flr(rnd(256)) - 128
    local y = flr(rnd(256)) - 128
    add(g.blobs, blob_type:new(x, y, 4))
  end
end

function _update60()
  if (btn(0)) g.mouse.x -= 2
  if (btn(1)) g.mouse.x += 2
  if (btn(2)) g.mouse.y -= 2
  if (btn(3)) g.mouse.y += 2
  g.blob:update()
  if g.mouse.x < g.blob.pos.x - 64 then
    g.mouse.x = g.blob.pos.x - 64
  elseif g.mouse.x > g.blob.pos.x + 64 then
    g.mouse.x = g.blob.pos.x + 64
  end
  if g.mouse.y < g.blob.pos.y - 64 then
    g.mouse.y = g.blob.pos.y - 64
  elseif g.mouse.y > g.blob.pos.y + 64 then
    g.mouse.y = g.blob.pos.y + 64
  end
  camera(g.blob.pos.x - 64, g.blob.pos.y - 64)
  for blob in all(g.blobs) do
    if g.blob:eats(blob) then
      del(g.blobs, blob)
    end
  end
end

function _draw()
  cls(1)
  -- todo: implement scale(), maybe using a parameter to blob:show()
  g.blob:show(g.blob.r)
  for blob in all(g.blobs) do
    blob:show(g.blob.r)
  end
  draw_crosshair(g.mouse.x, g.mouse.y)
end

function draw_crosshair(x, y)
  pset(x - 1, y, 7)
  pset(x + 1, y, 7)
  pset(x, y - 1, 7)
  pset(x, y + 1, 7)
  pset(x - 2, y, 6)
  pset(x + 2, y, 6)
  pset(x, y - 2, 6)
  pset(x, y + 2, 6)
  pset(x - 3, y, 5)
  pset(x + 3, y, 5)
  pset(x, y - 3, 5)
  pset(x, y + 3, 5)
end

-->8

blob_type = { }

function blob_type:new(x, y, r)
  local o = {
    pos = vector_type:new(x, y),
    r = r
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function blob_type:update()
  local vel = g.mouse:copy()
  vel:sub(self.pos)
  if (vel:magnitude() > 2) then
    vel:set_mag(0.75)
    self.pos:add(vel)
  end
end

function blob_type:eats(other)
  local d = vector_type.dist_16bit(self.pos, other.pos)
  if d < self.r + other.r then
    local sum = 3.14 * self.r ^ 2 + 3.14 * other.r ^ 2
    self.r = sqrt(sum / 3.14)
    return true
  end
  return false
end

function blob_type:show(player_r)
  circfill(self.pos.x, self.pos.y, self.r, 7)
  circ(self.pos.x, self.pos.y, self.r, 0)
end
