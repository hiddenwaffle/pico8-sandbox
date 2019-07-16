pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/vector2.p8

local segments

function _init()
  segments = { }
  local a = vector2_type:new(0, 21)
  local b = vector2_type:new(128, 21)
  local len = vector2_type.distance(a, b)
  local h = len * sqrt(3) / 2
  local c = vector2_type:new(64, 21 + h)
  local s1 = segment_type:new(a, b)
  local s2 = segment_type:new(b, c)
  local s3 = segment_type:new(c, a)
  add(segments, s1)
  add(segments, s2)
  add(segments, s3)
  -- local start = segment_type:new(a, b)
  -- add(segments, start)
  -- local children = start:generate()
  -- add_all(children, segments)
end

function _update60()
  if btnp(5) then
    local next_generation = { }
    for s in all(segments) do
      local children = s:generate()
      add_all(children, next_generation)
    end
    segments = next_generation
  end
end

function _draw()
  cls(1)
  for s in all(segments) do
    s:show()
  end
  print(stat(0), 4, 4)
  print('press x to iterate', 4, 11, 12)
end

-->8

segment_type = { }

function segment_type:new(a, b)
  local o = {
    a = a:copy(),
    b = b:copy()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function segment_type:generate()
  local children = { }
  local v = self.b:subtract(self.a)
  v:scale_in_place(1 / 3)
  -- segment 1
  local b1 = self.a:add(v)
  children[1] = segment_type:new(self.a, b1)
  -- segment 4
  local a1 = self.b:subtract(v)
  children[4] = segment_type:new(a1, self.b)
  -- segment 2
  v:rotate_in_place(1 / 6)
  local c = b1:add(v)
  children[2] = segment_type:new(b1, c)
  -- segment 3
  children[3] = segment_type:new(c, a1)
  return children
end

function segment_type:show()
  line(self.a.x, self.a.y, self.b.x, self.b.y, 7)
  -- circfill(self.a.x, self.a.y, 2, 8)
  -- circfill(self.b.x, self.b.y, 2, 8)
end

-->8

function add_all(from, to)
  for x in all(from) do
    add(to, x)
  end
end
