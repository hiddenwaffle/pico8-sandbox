pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=MPmLWsHzPlU

#include lib/matrix.p8:0
#include lib/neural-network.p8:0

g = { }

function _init()
  local nn = neural_network_type:new(2, 2, 1)
  local input = { 1, 0 }
  local output = nn:feed_forward(input)
  foreach(output, print)
end

-- function _update60()
-- end

-- function _draw()
-- end
