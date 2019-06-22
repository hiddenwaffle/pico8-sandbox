pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #98.3
-- https://www.youtube.com/watch?v=z0YFFg_nBjw

-- without quadtree
-- 76k ram
-- 8.6 cpu load

-- with quadtree
-- 80k - 200k ram
-- 3.5 cpu load

#include lib/quadtree.p8:0
g = { }

function _init()
  g.particles = { }
  for i = 1, 100 do
    local particle =  particle_type:new(flr(rnd(128)), flr(rnd(128)))
    add(g.particles, particle)
  end
end

function _update60()
end

function _draw()
  cls(1)
  local boundary = rectangle_type:new(0, 0, 128, 128)
  local qtree = quad_tree_type:new(boundary, 4)
  for p in all(g.particles) do
    local point = point_type:new(p.x, p.y, p)
    qtree:insert(point)
    p:move()
    p:render()
    p:set_highlight(false)
  end
  for p in all(g.particles) do
    local range = rectangle_type:new(p.x - 15,
                                     p.y - 15,
                                     30,
                                     30)
    local points = qtree:query(range)
    for point in all(points) do
      local other = point.userdata
    -- for other in all(g.particles) do -- comment previous 3 lines and uncomment this one to get brute force
      if p != other and p:intersects(other) then
        p:set_highlight(true)
      end
    end
  end
  print(stat(0), 4, 4, 11)
  print(stat(1), 4, 11, 11)
end

-->8

particle_type = { }

function particle_type:new(x, y)
  local o = {
    x = x,
    y = y,
    r = 2,
    highlight = false
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function particle_type:intersects(other)
  local d = dist_16bit(self.x, self.y, other.x, other.y)
  return d < self.r + other.r
end

function particle_type:set_highlight(value)
  self.highlight = value
end

function particle_type:move()
  self.x += flr(rnd(3)) - 1
  self.y += flr(rnd(3)) - 1
end

function particle_type:render()
  local color
  if self.highlight then
    color = 10
  else
    color = 13
  end
  circfill(self.x, self.y, self.r, color)
end

-->8

-- taken from vector2d lib
function dist_16bit(x1, y1, x2, y2)
  local x1 *= 0.001
  local x2 *= 0.001
  local y1 *= 0.001
  local y2 *= 0.001
  local a = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
  return a / 0.001
end
