pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- had to negate all sines to make it look like the video

-- coding challenge #93
-- https://www.youtube.com/watch?v=uWzPe_S-RVE

-- #include lib/vector2d.p8:0

g = { }

function _init()
  g.cx = -64
  g.cy = -16
  camera(g.cx, g.cy)
  g.r1 = 40
  g.r2 = 40
  g.m1 = 5
  g.m2 = 5
  g.a1 = 1 / 6
  g.a2 = 1 / 15
  g.a1_v = 0
  g.a2_v = 0
  g.trail = point_list_type:new()
end

function _update60()
  local gravity = 1
  -- a1
  local num1 = -gravity * (2 * g.m1 + g.m2) * -sin(g.a1)
  local num2 = -g.m2 * gravity * -sin(g.a1 - 2 * g.a2)
  local num3 = -2 * -sin(g.a1 - g.a2) * g.m2
  local num4 = g.a2_v * g.a2_v * g.r2 + g.a1_v * g.a1_v * g.r1 * cos(g.a1 - g.a2)
  local den = g.r1 * (2 * g.m1 + g.m2 - g.m2 * cos(2 * g.a1 - 2 * g.a2))
  local a1_a = (num1 + num2 + num3 * num4) / den
  -- a2
  num1 = 2 * -sin(g.a1 - g.a2)
  num2 = (g.a1_v * g.a1_v * g.r1 * (g.m1 + g.m2))
  num3 = gravity * (g.m1 + g.m2) * cos(g.a1)
  num4 = g.a2_v * g.a2_v * g.r2 * g.m2 * cos(g.a1 - g.a2)
  den = g.r2 * (2 * g.m1 + g.m2 - g.m2 * cos(2 * g.a1 - 2 * g.a2))
  local a2_a = (num1 * (num2 + num3 + num4)) / den
  -- scale down due to resolution?
  a1_a *= 0.01
  a2_a *= 0.01
  -- apply movement
  g.a1_v += a1_a
  g.a2_v += a2_a
  g.a1 += g.a1_v
  g.a2 += g.a2_v
  -- dampening
  g.a1_v *= 0.999
  g.a2_v *= 0.999
end

function _draw()
  cls(1)
  local x1 = g.r1 * -sin(g.a1)
  local y1 = g.r1 * cos(g.a1)
  local x2 = x1 + g.r2 * -sin(g.a2)
  local y2 = y1 + g.r2 * cos(g.a2)
  g.trail:add(x2, y2)
  for point in all(g.trail.points) do
    pset(point.x, point.y, 13)
  end
  line(0, 0, x1, y1, 7)
  line(x1, y1, x2, y2, 7)
  circfill(x1, y1, g.m1, 3)
  circ(x1, y1, g.m1, 11)
  circfill(x2, y2, g.m2, 3)
  circ(x2, y2, g.m2, 11)
end

-->8

point_list_type = { }

function point_list_type:new(max_size)
  local o = {
    points = { },
    max_size = max_size or 300
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function point_list_type:add(x, y)
  add(self.points, { x = x, y = y})
  if #self.points > self.max_size then
    del(self.points, self.points[1])
  end
end
