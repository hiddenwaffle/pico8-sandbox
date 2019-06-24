pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- based on:
-- https://github.com/CodingTrain/website/tree/master/CodingChallenges/CC_092_xor/P5/libraries

#include lib/matrix.p8:0
#include lib/neural-network.p8:0

g = { }

function _init()
  cls()
  local training_data = {
    {
      inputs = { 0, 0 },
      targets = { 0 }
    },
    {
      inputs = { 1, 0 },
      targets = { 1 }
    },
    {
      inputs = { 0, 1 },
      targets = { 1 }
    },
    {
      inputs = { 1, 1 },
      targets = { 0 }
    }
  }
  local nn = neural_network_type:new(2, 2, 1)
  local iterations = 32767
  for outer_i = 1, 100 do
    for current_iteration = 1, iterations do
      local index = flr(rnd(4)) + 1
      local data = training_data[index]
      nn:train(data.inputs, data.targets)
      if current_iteration % 1000 == 0 then
        print(outer_i .. ' / ' .. 100 .. ' and ' .. current_iteration .. ' / ' .. iterations)
      end
    end
  end
  foreach(nn:feedforward({1, 0}), print) -- 1
  foreach(nn:feedforward({0, 1}), print) -- 1
  foreach(nn:feedforward({0, 0}), print) -- 0
  foreach(nn:feedforward({1, 1}), print) -- 0
end

-- function _update60()
-- end

-- function _draw()
-- end
