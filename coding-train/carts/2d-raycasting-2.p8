pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #146
-- https://www.youtube.com/watch?v=vYgIKn7iDH8

#include lib/vector2d.p8

g = { }

function _init()
  g.infinity = 32767
  g.scene_w = 64
  g.scene_h = 64
  g.walls = { }
  for i = 1, 5 do
    local x1 = flr(rnd(128))
    local y1 = flr(rnd(128))
    local x2 = flr(rnd(128))
    local y2 = flr(rnd(128))
    add(g.walls, boundary_type:new(x1, y1, x2, y2))
  end
  g.particle = particle_type:new()
end

function _update60()
  if btn(0) then
    g.particle:rotate(0.01)
  end
  if btn(1) then
    g.particle:rotate(-0.01)
  end
  if btn(2) then
    g.particle:move(1)
  end
  if btn(3) then
    g.particle:move(-1)
  end
end

function _draw()
  cls(1)
  -- top-down view
  for wall in all(g.walls) do
    wall:show()
  end
  g.particle:show()
  -- fps view
  rectfill(0, 32, 64, 96, 0)
  local scene = g.particle:look(g.walls)
  local w = g.scene_w / #scene
  for i = 1, #scene do
    if scene[i] == g.infinity then
      -- do nothing
    else
      local x1 = (#scene - i) * w
      local y1 = 32
      local x2 = (#scene - i + 1) * w
      local y2 =  96
      -- scale y1 and y2 by inverse of scene[i] value
      -- not sure if this is totally accurate
      -- probably would be better to scale it to a certain size rather than each endpoint because it can flip vertically if far enough away.
      local scale = (scene[i] / 128) * (g.scene_h / 2)
      y1 += scale
      y2 -= scale
      -- draw it
      local color = 7 - (scene[i] / 181) * 3 -- 181 is farthest possible
      rectfill(x1, y1, x2, y2, color)
    end
  end
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

function ray_type:set_angle(angle)
  self.dir = vector2d_type.from_angle(angle)
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
    rays = { },
    ray_count_circle = 128, -- 128 rays would be a circl
    heading = 0
  }
  local fov_rays = o.ray_count_circle / 8 -- 8 gives 45 degrees fov
  for a = -o.ray_count_circle / fov_rays, o.ray_count_circle / fov_rays do
    add(o.rays, ray_type:new(o.pos, a / o.ray_count_circle))
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function particle_type:rotate(angle)
  self.heading += angle
  for i = 1, #self.rays do
    self.rays[i]:set_angle(i / self.ray_count_circle + self.heading)
  end
end

function particle_type:move(amt)
  local vel = vector2d_type.from_angle(self.heading)
  vel:set_mag(amt)
  self.pos:add(vel)
end

function particle_type:update(x, y)
  self.pos.x = x
  self.pos.y = y
end

function particle_type:look(walls)
  local scene = { }
  for i = 1, #self.rays do
    local ray = self.rays[i]
    local closest = nil
    local record = g.infinity
    for wall in all(walls) do
      local pt = ray:cast(wall)
      if pt then
        local d = vector2d_type.dist_16bit(self.pos, pt)
        -- todo: fix fisheye effect here (see 24:19 in the video)
        if d < record then
          record = d
          closest = pt
        end
      end
    end
    if closest then
      line(self.pos.x, self.pos.y, closest.x, closest.y, 10)
      scene[i] = record
    end
    scene[i] = record
  end
  return scene
end

function particle_type:show()
  circfill(self.pos.x, self.pos.y, 2, 9)
end
