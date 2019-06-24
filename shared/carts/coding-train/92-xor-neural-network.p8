pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- uses 4 hidden nodes instead of 2
-- stabilizes after about a minute. maxes out cpu x15 times.

-- coding challenge #92
-- https://www.youtube.com/watch?v=188B6k_F9jU

#include lib/matrix.p8:0
#include lib/neural-network.p8:0

g = { }

function _init()
  g.iterations = 0
  g.nn = neural_network_type:new(2, 4, 1) -- change the middle argument for fun and profit
  g.training_data = {
    {
      inputs = { 0, 0 },
      outputs = { 0 }
    },
    {
      inputs = { 1, 0 },
      outputs = { 1 }
    },
    {
      inputs = { 0, 1 },
      outputs = { 1 }
    },
    {
      inputs = { 1, 1 },
      outputs = { 0 }
    }
  }
  g._10 = 0
  g._01 = 0
  g._00 = 0
  g._11 = 0
end

function _update60()
  if (btn(0)) g.nn.learning_rate -= 0.01
  if (btn(1)) g.nn.learning_rate += 0.01
  local iterations = 100 --32767
  for current_iteration = 1, iterations do
    local index = flr(rnd(4)) + 1
    local data = g.training_data[index]
    g.nn:train(data.inputs, data.outputs)
  end
  g._10 = g.nn:feedforward({1, 0})[1] -- 1
  g._01 = g.nn:feedforward({0, 1})[1] -- 1
  g._00 = g.nn:feedforward({0, 0})[1] -- 0
  g._11 = g.nn:feedforward({1, 1})[1] -- 0
end

function _draw()
  -- cls(1)
  local resolution = 8
  local cols = flr(128 / resolution)
  local rows = flr(128 / resolution)
  for i = 0, cols do
    for j = 0, rows do
      local x1 = i / cols
      local x2 = j / rows
      local inputs = { x1, x2 }
      local y = g.nn:feedforward(inputs)
      -- printh(x1 .. ' and ' .. x2 .. ' => ' .. y[1], 'log')
      local col = to_color(y[1])
      rectfill(i * resolution, j * resolution,
               (i + 1) * resolution, (j + 1) * resolution,
               col)
    end
  end
  print(stat(1), 4, 4, 11)
  print(g.nn.learning_rate, 4, 11, 11)
  print('1 0 = ' .. g._10, 4, 18, 12)
  print('0 1 = ' .. g._01, 4, 25, 12)
  print('0 0 = ' .. g._00, 4, 32, 12)
  print('1 1 = ' .. g._11, 4, 39, 12)
end

-->8

function to_color(y)
  local r = flr(y * 5) -- local r = flr(rnd(5)) + 1
  if (r == 0) return 0
  if (r == 1) return 1
  if (r == 2) return 5
  if (r == 3) return 6
  if (r == 4) return 7
end
