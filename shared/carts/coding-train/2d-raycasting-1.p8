pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #145
-- https://www.youtube.com/watch?v=TOEi6T2mtHo

#include lib/vector2d.p8

g = { }

function _init()
  g.walls = { }
  for i = 1, 5 do
    local x1 = flr(rnd(128))
    local y1 = flr(rnd(128))
    local x2 = flr(rnd(128))
    local y2 = flr(rnd(128))
    add(g.walls, boundary_type:new(x1, y1, x2, y2))
  end
  g.particle = particle_type:new()
  g.mouse = { x = 64, y = 64 }
end

function _update60()
  update_mouse()
  g.particle:update(g.mouse.x, g.mouse.y)
end

function update_mouse()
  if (btn(0)) g.mouse.x -= 1
  if (btn(1)) g.mouse.x += 1
  if (btn(2)) g.mouse.y -= 1
  if (btn(3)) g.mouse.y += 1
  if (g.mouse.x < 0) g.mouse.x = 0
  if (g.mouse.x > 127) g.mouse.x = 127
  if (g.mouse.y < 0) g.mouse.y = 0
  if (g.mouse.y > 127) g.mouse.y = 127
end

function _draw()
  cls(1)
  for wall in all(g.walls) do
    wall:show()
  end
  g.particle:look(g.walls)
  g.particle:show()
end

-->8

boundary_type = { }

function boundary_type:new(x1, y1, x2, y2)
  local o = {
    a = vector2d_type:new(x1, y1),
    b = vector2d_type:new(x2, y2)
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function boundary_type:show()
  line(self.a.x, self.a.y, self.b.x, self.b.y, 7)
end

-->8

ray_type = { }

function ray_type:new(pos, angle)
  local o = {
    pos = pos,
    dir = vector2d_type.from_angle(angle)
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function ray_type:look_at(x, y)
  self.dir.x = x - self.pos.x
  self.dir.y = y - self.pos.y
  self.dir:normalize()
end

function ray_type:show()
  line(self.pos.x, self.pos.y,
       self.pos.x + self.dir.x * 3, self.pos.y + self.dir.y * 3,
       10)
end

function ray_type:cast(wall)
  -- from wikipedia "line-to-line intersection"
  local x1 = wall.a.x
  local y1 = wall.a.y
  local x2 = wall.b.x
  local y2 = wall.b.y
  local x3 = self.pos.x
  local y3 = self.pos.y
  local x4 = self.pos.x + self.dir.x
  local y4 = self.pos.y + self.dir.y
  local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  if den == 0 then
    return
  end
  local t =  ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
  local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den
  if t > 0 and t < 1 and u > 0 then
    local pt = vector2d_type:new()
    pt.x = x1 + t * (x2 - x1)
    pt.y = y1 + t * (y2 - y1)
    return pt
  else
    return
  end
end

-->8

particle_type = { }

function particle_type:new()
  local o = {
    pos = vector2d_type:new(64, 64),
    rays = { }
  }
  local ray_count = 128 -- worth it to be same as resolution?
  for a = 0, ray_count - 1 do
    add(o.rays, ray_type:new(o.pos, a / ray_count))
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function particle_type:update(x, y)
  self.pos.x = x
  self.pos.y = y
end

function particle_type:look(walls)
  for ray in all(self.rays) do
    local closest = nil
    local record = 32767
    for wall in all(walls) do
      local pt = ray:cast(wall)
      if pt then
        local d = vector2d_type.dist_16bit(self.pos, pt)
        if d < record then
          record = d
          closest = pt
        end
      end
    end
    if closest then
      line(self.pos.x, self.pos.y, closest.x, closest.y, 10)
    end
  end
end

function particle_type:show()
  circfill(self.pos.x, self.pos.y, 2, 9)
end
