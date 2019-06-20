pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #64.2
-- https://www.youtube.com/watch?v=hbgDqyy8bIw

#include lib/vector2d.p8:0
#include lib/os2d.p8:0
#include lib/math.p8:0

g = { }

function _init()
  local length = 1
  local segments = 100
  local current = segment_type:new(64, 64, length)
  for i = 2, segments do
    local next = segment_type:new_from_parent(current, length, 0)
    current.child = next
    current = next
  end
  g.head = current
  g.mouse = { x = 64, y = 44}
end

function _update60()
  update_mouse()
  g.head:follow(g.mouse.x, g.mouse.y)
  g.head:update()
  local next = g.head.parent
  while next do
    next:follow_2()
    next:update()
    next = next.parent
  end
end

function update_mouse()
  local speed = 1
  if (btn(0)) g.mouse.x -= speed
  if (btn(1)) g.mouse.x += speed
  if (btn(2)) g.mouse.y -= speed
  if (btn(3)) g.mouse.y += speed
end

function _draw()
  cls(1)
  local next = g.head
  while next do
    next:show()
    next = next.parent
  end
  draw_mouse()
end

function draw_mouse()
  local x = g.mouse.x
  local y = g.mouse.y
  for i = 1, 2 do
    pset(x, y + i, 5 + i)
    pset(x, y - i, 5 + i)
    pset(x - i, y, 5 + i)
    pset(x + i, y, 5 + i)
  end
end

-->8

segment_type = { }

function segment_type:new(x, y, len)
  local o = {
    a = vector2d_type:new(x, y),
    b = vector2d_type:new(),
    len = len,
    angle = 0,
    parent = nil,
    child = nil
  }
  setmetatable(o, self)
  self.__index = self
  o:calculate_b()
  return o
end

function segment_type:new_from_parent(parent, len, i)
  local seg = segment_type:new(parent.b.x, parent.b.y, len)
  seg.parent = parent
  return seg
end

-- for head
function segment_type:follow(tx, ty)
  local target = vector2d_type:new(tx, ty)
  local dir = target:copy():sub(self.a)
  self.angle = dir:heading()
  dir:set_mag(self.len)
  dir:mult(-1)
  self.a = target:copy():add(dir)
end

-- for tail
function segment_type:follow_2()
  local target_x = self.child.a.x
  local target_y = self.child.a.y
  self:follow(target_x, target_y)
end

function segment_type:calculate_b()
  local dx = self.len * cos(self.angle)
  local dy = self.len * sin(self.angle)
  self.b:set(self.a.x + dx, self.a.y + dy)
end

function segment_type:update()
  self:calculate_b()
end

function segment_type:show()
  line(self.a.x, self.a.y, self.b.x, self.b.y, 7)
end
