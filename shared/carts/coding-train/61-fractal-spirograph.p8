pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #61
-- https://www.youtube.com/watch?v=0dwJ-bkJwDI

#include lib/vector2d.p8:0
#include lib/shape2d.p8:0

g = { }

function _init()
  g.sun = orbit_type:new(64, 64, 30, 0 )
  local next = g.sun
  for i = 1, 20 do
    next = next:add_child()
    g.last = next
  end
  g.path = { }
end

function _update60()
  if (#g.path > 500) return -- prevent too many path elements
  local next = g.sun
  while next do
    next:update()
    next = next.child
  end
  add(g.path, vector2d_type:new(g.last.x, g.last.y))
end

function _draw()
  cls(1)
  local next = g.sun
  while next do
    next:show()
    next = next.child
  end
  print(#g.path, 4, 4, 11)
  shape2d(g.path, 14, false)
end

-->8

orbit_type = { }

k = -4 -- todo: move to g
function orbit_type:new(x, y, r, n, p)
  local o = {
    x = x,
    y = y,
    r = r,
    n = n,
    parent = p,
    child = nil,
    angle = 0.25, -- 0.25 rotates the star to point up-ish
    speed = k ^ (n - 1) * 0.01 -- 0.01 to scale it down
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function orbit_type:add_child()
  local newr = self.r * 0.39
  local newx = self.x + self.r + newr
  local newy = self.y
  self.child = orbit_type:new(newx, newy, newr, self.n + 1, self)
  return self.child
end

function orbit_type:update()
  if self.parent then
    self.angle += self.speed
    local rsum = self.r + self.parent.r -- change + to - to make it go inside the circle
    self.x = self.parent.x + rsum * cos(self.angle)
    self.y = self.parent.y + rsum * sin(self.angle)
  end
end

function orbit_type:show()
  circ(self.x, self.y, self.r, 7)
end
