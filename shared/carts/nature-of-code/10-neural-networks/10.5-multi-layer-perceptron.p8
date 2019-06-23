pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=IlmNhFxre0w

g = { }

function _init()
  g.brain = neural_network_type:new(3, 3, 1)
end

function _update60()
end

function _draw()
end

-->8

neural_network_type = { }

function neural_network_type:new(num_i, num_h, num_o)
  local o = {
    input_nodes = num_i,
    hidden_nodes = num_h,
    output_nodes = num_o
  }
  setmetatable(o, self)
  self.__index = index
  return o
end
