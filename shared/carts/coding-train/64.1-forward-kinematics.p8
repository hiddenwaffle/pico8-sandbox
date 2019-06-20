pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #64.1
-- https://www.youtube.com/watch?v=xXjRlEr7AGk

#include lib/vector2d.p8:0
#include lib/os2d.p8:0
#include lib/math.p8:0

g = { }

function _init()
  os2d_noise()
  g.tentacle = segment_type:new(64, 112, 5, 0)
  local current = g.tentacle
  for i = 1, 10 do
    local next = segment_type:new_with_parent(current, 10, 0)
    current.child = next
    current = next
  end
end

function _update60()
  local next = g.tentacle
  while next do
    next:wiggle()
    next:update()
    next = next.child
  end
end

function _draw()
  cls(1)
  local next = g.tentacle
  while next do
    next:show()
    next = next.child
  end
end

-->8

segment_type = { }

function segment_type:new(x, y, len, angle)
  local o = {
    a = vector2d_type:new(x, y),
    len = len,
    angle = angle,
    self_angle = angle,
    parent = nil,
    child = nil,
    xoff = rnd(1000)
  }
  setmetatable(o, self)
  self.__index = self
  o:calculate_b()
  return o
end

function segment_type:new_with_parent(parent, len, angle)
  local seg = segment_type:new(parent.b.x, parent.b.y, len, angle)
  seg.parent = parent
  return seg
end

function segment_type:wiggle()
  local minangle = 0 / 360
  local maxangle = 40 / 360
  self.self_angle = math_map(os2d_eval(self.xoff, self.xoff), 0, 1, minangle, maxangle)
  -- self.self_angle = math_map(sin(self.xoff, self.xoff), 0, 1, minangle, maxangle)
  self.xoff += 0.005
end

function segment_type:update()
  self.angle = self.self_angle
  if self.parent then
    self.a = self.parent.b:copy()
    self.angle += self.parent.angle
  else
    self.angle = 0.25
  end
  self:calculate_b()
end

function segment_type:calculate_b()
  local dx = self.len * cos(self.angle)
  local dy = self.len * sin(self.angle)
  self.b = vector2d_type:new(self.a.x + dx, self.a.y + dy)
end

function segment_type:show()
  line(self.a.x, self.a.y, self.b.x, self.b.y, 7)
end
