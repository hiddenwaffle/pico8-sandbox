pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/vector2d.p8:0
#include lib/shape2d.p8:0

g = { }

function _init()
  g.angle = 0
  g.w = 16
  g.cols = 128 / g.w - 1
  g.rows = g.cols
  g.curves = { }
  for row = 1, g.rows do
    g.curves[row] = { }
    for col = 1, g.cols do
      g.curves[row][col] = curve_type:new()
    end
  end
  g.done = false
end

function _update60()
  if (g.done) return
  g.angle += 0.02 -- needs to be fast to not go out of mem
  if (g.angle > 1) then
    for row = 1, g.rows do
      for col = 1, g.cols do
        g.curves[row][col]:reset()
      end
    end
    g.done = true
  end
end

function _draw()
  if (g.done) then
    print('done', 4, 11, 9)
    return
  end
  local r = g.w - 9
  cls()
  for i = 0, g.cols - 1 do
    local cx = g.w + i * g.w + g.w / 2
    local cy = g.w / 2
    circ(cx, cy, r, 7)
    local x = r * cos(g.angle * (i + 1) + 0.25)
    local y = r * sin(g.angle * (i + 1) + 0.25)
    line(cx + x, 0, cx + x, 128, 5)
    pset(cx + x, cy + y, 8)
    for j = 0, g.rows - 1 do
      g.curves[j + 1][i + 1]:set_x(cx + x)
    end
  end
  for j = 0, g.rows - 1 do
    local cx = g.w / 2
    local cy = g.w + j * g.w + g.w / 2
    circ(cx, cy, r, 7)
    local x = r * cos(g.angle * (j + 1) + 0.25)
    local y = r * sin(g.angle * (j + 1) + 0.25)
    line(0, cy + y, 128, cy + y, 5)
    pset(cx + x, cy + y, 8)
    for i = 0, g.cols - 1 do
      g.curves[j + 1][i + 1]:set_y(cy + y)
    end
  end
  for row = 1, g.rows do
    for col = 1, g.cols do
      g.curves[row][col]:add_point()
      g.curves[row][col]:show()
    end
  end
  print(stat(0), 4, 4, 10)
end

-->8

curve_type = { }

function curve_type:new()
  local o = {
    path = { },
    current = vector2d_type:new()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function curve_type:set_x(x)
  self.current.x = x
end

function curve_type:set_y(y)
  self.current.y = y
end

function curve_type:add_point()
  add(self.path, self.current)
  if #self.path > 100 then
    del(self.path, self.path[1])
  end
  self.current = vector2d_type:new()
end

function curve_type:reset()
  self.path = { }
end

function curve_type:show()
  local shape = { }
  for v in all(self.path) do
    assert(v.x)
    assert(v.y)
    add(shape, { x = v.x, y = v.y })
  end
  shape2d(shape, 7)
end
