pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- 3.4 linear regression with gradient descent
-- https://www.youtube.com/watch?v=L-Lsfu4ab74

#include lib/vector2d.p8:0
#include lib/math.p8:0

g = { }
width = 128
height = 128

function _init()
  g.mouse = { x = 64, y = 64 }
  g.data = { }
  g.m = 1
  g.b = 0
end

function _update60()
  update_mouse()
  if btnp(4) or btnp(5) then
    local x = math_map(g.mouse.x,
                       0, width - 1,
                       0, 1)
    local y = math_map(g.mouse.y,
                       0, height - 1,
                       1, 0)
    local point = vector2d_type:new(x, y)
    add(g.data, point)
  end
end

function update_mouse()
  if (btn(0)) g.mouse.x -= 1
  if (btn(1)) g.mouse.x += 1
  if (btn(2)) g.mouse.y -= 1
  if (btn(3)) g.mouse.y += 1
end

function _draw()
  cls(1)
  for datum in all(g.data) do
    local x = math_map(datum.x, 0, 1, 0, width)
    local y = math_map(datum.y, 0, 1, height, 0)
    circfill(x, y, 1, 7)
  end
  if #g.data > 1 then
    gradient_descent()
    draw_line()
  end
  draw_mouse()
end

function gradient_descent()
  local learning_rate = 0.05
  for datum in all(g.data) do
    local x = datum.x
    local y = datum.y
    local guess = g.m * x + g.b
    local error = y - guess
    g.m += (error * x) * learning_rate
    g.b += (error)     * learning_rate
  end
end

function draw_line()
  local x1 = 0
  local y1 = g.m * x1 + g.b
  local x2 = 1
  local y2 = g.m * x2 + g.b
  x1 = math_map(x1, 0, 1, 0, width)
  y1 = math_map(y1, 0, 1, height, 0)
  x2 = math_map(x2, 0, 1, 0, width)
  y2 = math_map(y2, 0, 1, height, 0)
  line(x1, y1, x2, y2, 14)
end

function draw_mouse()
  local x = g.mouse.x
  local y = g.mouse.y
  pset(x - 1, y, 7)
  pset(x + 1, y, 7)
  pset(x, y - 1, 7)
  pset(x, y + 1, 7)
  pset(x - 2, y, 6)
  pset(x + 2, y, 6)
  pset(x, y - 2, 6)
  pset(x, y + 2, 6)
  pset(x - 3, y, 5)
  pset(x + 3, y, 5)
  pset(x, y - 3, 5)
  pset(x, y + 3, 5)
end
