pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=ntKn5TPHHAk

#include lib/math.p8:0

g = { }
width = 128
height = 128

function _init()
  g.mouse = { x = 64, y = 64 }
  g.brain = perceptron_type:new(3)
  g.points = { }
  for i = 1, 50 do
    g.points[i] = point_type:new()
  end
  g.training_index = 1
  g.iteration = 0
  g.done = false
end

function _update60()
  update_mouse()
  if (g.done) return
  g.iteration += 1
  g.t = 0
  -- train only one point at a time for visual effect
  local training = g.points[g.training_index]
  local inputs = { training.x, training.y, training.bias }
  local target = training.label
  g.brain:train(inputs, target)
  g.training_index += 1
  if (g.training_index > #g.points) g.training_index = 1
end

function update_mouse()
  if (btn(0)) g.mouse.x -= 1
  if (btn(1)) g.mouse.x += 1
  if (btn(2)) g.mouse.y -= 1
  if (btn(3)) g.mouse.y += 1
end

function _draw()
  cls(0)
  -- real dividing line
  local p1 = point_type:new(-1, f(-1))
  local p2 = point_type:new( 1, f( 1))
  local p1x, p1y = p1:pixel()
  local p2x, p2y = p2:pixel()
  line(p1x, p1y, p2x, p2y, 14)
  -- perceptron's dividing line
  local p3 = point_type:new(-1, g.brain:guess_y(-1))
  local p4 = point_type:new( 1, g.brain:guess_y( 1))
  local p3x, p3y = p3:pixel()
  local p4x, p4y = p4:pixel()
  line(p3x, p3y, p4x, p4y, 15)
  --
  for pt in all(g.points) do
    pt:show()
  end
  local total_good = 0
  for pt in all(g.points) do
    local inputs = { pt.x, pt.y, pt.bias }
    local target = pt.label
    -- g.brain:train(inputs, target) -- moved to update()
    local guess = g.brain:guess(inputs)
    local color
    if guess == target then
      color = 11
      total_good += 1
    else
      color = 8
    end
    local px, py = pt:pixel()
    circfill(px, py, 1, color)
  end
  if (total_good == #g.points) g.done = true -- todo: ought to be in update()
  local y_offset = 4
  print(g.iteration, 4, y_offset, 7)
  y_offset += 7
  for weight in all(g.brain.weights) do
    print(weight, 4, y_offset, 7)
    y_offset += 7
  end
  if (g.done) print('done', 4, y_offset, 10)
  draw_mouse()
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

-->8

perceptron_type = { }

function perceptron_type:new(n)
  local o = {
    weights = { },
    lr = 0.01
  }
  -- initialize weights randomly
  for i = 1, n do
    o.weights[i] = rnd(2) - 1
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function perceptron_type:guess(inputs)
  local sum = 0
  for i = 1, #self.weights do
    sum += inputs[i] * self.weights[i]
  end
  local output = sgn(sum)
  return output
end

function perceptron_type:guess_y(x)
  local w0 = self.weights[1]
  local w1 = self.weights[2]
  local w2 = self.weights[3]
  return -(w2 / w1) - (w0 / w1) * x
end

function perceptron_type:train(inputs, target)
  local guess = self:guess(inputs)
  local error = target - guess
  -- tune all the weights
  for i = 1, #self.weights do
    self.weights[i] += error * inputs[i] * self.lr
  end
end

-->8

point_type = { }

function point_type:new(x, y)
  local o = {
    x = x or rnd(2) - 1,
    y = y or rnd(2) - 1,
    bias = 1
  }
  local line_y = f(o.x)
  o.label = o.y > line_y and 1 or -1 -- ternary
  setmetatable(o, self)
  self.__index = self
  return o
end

function point_type:pixel()
  local px = math_map(self.x, -1, 1, 0, width)
  local py = math_map(self.y, -1, 1, height, 0)
  return px, py
end

function point_type:show()
  local color
  if self.label == 1 then
    color = 3
  else
    color = 1
  end
  local px, py = self:pixel()
  circfill(px, py, 3, color)
end

-->8

-- y = mx + b
-- m and b between 0.25 and 0.75 or -0.75 and -0.25
local sign1 = rnd(1) < 0.5 and -1 or 1
local sign2 = rnd(1) < 0.5 and -1 or 1
local _m = 0.25 + rnd(0.5) * sign1
local _b = 0.25 + rnd(0.5) * sign2
function f(x)
  return _m * x + _b
end
