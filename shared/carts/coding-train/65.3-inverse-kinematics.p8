pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #64.3
-- https://www.youtube.com/watch?v=10st01Z0jxc

#include lib/vector2d.p8:0
#include lib/os2d.p8:0
#include lib/math.p8:0

g = { }

function _init()
  g.mouse = { x = 64, y = 44}
  g.tentacles = { }
  local da = 1 / 5 -- denominator is # of tentacles
  local color = 7
  for a = 0, 1, da do
    local x = 64 + cos(a) * 40 * 1.5
    local y = 64 + sin(a) * 40
    add(g.tentacles, tentacle_type:new(x, y, color))
    color += 1
  end
  g.pos = vector2d_type:new(0, 0)
  g.vel = vector2d_type:new(0.666, 1)
  g.gravity = vector2d_type:new(0, 0.2)
end

function _update60()
  update_mouse()
  for tentacle in all(g.tentacles) do
    tentacle:update()
  end
  g.pos:add(g.vel)
  g.vel:add(g.gravity)
  if g.pos.x > 127 or g.pos.x < 0 then
    g.vel.x *= -1
  end
  if (g.pos.x > 127) g.pos.x = 127
  if (g.pos.x < 0) g.pos.x = 0
  if g.pos.y > 127 or g.pos.y < 0 then
    g.vel.y *= -1
  end
  if (g.pos.y > 127) g.pos.y = 127
  if (g.pos.y < 0) g.pos.y = 0
end

function _draw()
  cls(1)
  for tentacle in all(g.tentacles) do
    tentacle:show()
  end
  circ(g.pos.x, g.pos.y, 5, 14)
  draw_mouse()
end

-->8

function update_mouse()
  local speed = 2
  if (btn(0)) g.mouse.x -= speed
  if (btn(1)) g.mouse.x += speed
  if (btn(2)) g.mouse.y -= speed
  if (btn(3)) g.mouse.y += speed
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

tentacle_type = { }

function tentacle_type:new(x, y, color)
  local o = {
    segments = { },
    base = vector2d_type:new(x, y),
    len = 5,
    color = color
  }
  local total = 10
  o.segments[1] = segment_type:new(64, 64, o.len)
  for i = 2, total do
    o.segments[i] = segment_type:new_from_parent(o.segments[i - 1], o.len, i)
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function tentacle_type:update()
  local total = #self.segments
  local finish = self.segments[total]
  finish:follow(g.pos.x, g.pos.y) -- finish:follow(g.mouse.x, g.mouse.y)
  finish:update()
  for i = total - 1, 1, -1 do
    self.segments[i]:follow_2(self.segments[i + 1])
    self.segments[i]:update()
  end
  self.segments[1]:set_a(self.base)
  for i = 2, total do
    self.segments[i]:set_a(self.segments[i - 1].b)
  end
end

function tentacle_type:show()
  for seg in all(self.segments) do
    seg:show(self.color)
  end
end

-->8

segment_type = { }

function segment_type:new(x, y, len)
  local o = {
    a = vector2d_type:new(x, y),
    b = vector2d_type:new(),
    len = len,
    angle = 0
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
function segment_type:follow_2(child)
  self:follow(child.a.x, child.a.y)
end

function segment_type:set_a(pos)
  self.a = pos:copy()
  self:calculate_b()
end

function segment_type:calculate_b()
  local dx = self.len * cos(self.angle)
  local dy = self.len * sin(self.angle)
  self.b:set(self.a.x + dx, self.a.y + dy)
end

function segment_type:update()
  self:calculate_b()
end

function segment_type:show(color)
  line(self.a.x, self.a.y, self.b.x, self.b.y, color)
end
