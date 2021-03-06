pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=ntKn5TPHHAk

g = { }
width = 128
height = 128

function _init()
  g.mouse = { x = 64, y = 64 }
  g.brain = perceptron_type:new()
  g.points = { }
  for i = 1, 50 do
    g.points[i] = point_type:new()
  end
  g.inputs = { -1, 0.5 }
  g.training_index = 1
  g.iteration = 0
  g.done = false
end

function _update60()
  if (g.done) return
  g.iteration += 1
  g.t = 0
  update_mouse()
  -- train only one point at a time for visual effect
  local training = g.points[g.training_index]
  local inputs = { training.x, training.y }
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
  line(0, 0, width - 1, height - 1, 14)
  for pt in all(g.points) do
    pt:show()
  end
  local total_good = 0
  for pt in all(g.points) do
    local inputs = { pt.x, pt.y }
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
    circfill(pt.x, pt.y, 1, color)
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

function perceptron_type:new()
  local o = {
    weights = { },
    lr = 0.01
  }
  -- initialize weights randomly
  for i = 1, 2 do
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

function point_type:new()
  local o = {
    x = flr(rnd(128)),
    y = flr(rnd(128)),
  }
  o.label = o.x > o.y and 1 or -1 -- ternary
  setmetatable(o, self)
  self.__index = self
  return o
end

function point_type:show()
  local color
  if self.label == 1 then
    color = 3
  else
    color = 1
  end
  circfill(self.x, self.y, 3, color)
end
