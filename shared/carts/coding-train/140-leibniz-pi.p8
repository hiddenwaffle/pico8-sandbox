pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=uH4trBNn540

#include lib/math.p8

local pi = 4
local iterations = 0
local history = { }
local width = 128
local height = 128

function _init()
end

function _update60()
  local den = iterations * 2 + 3
  if iterations % 2 == 0 then
    pi -= (4 / den)
  else
    pi += (4 / den)
  end
  add(history, pi)
  iterations += 1
end

function _draw()
  local min_y = 2
  local max_y = 4
  cls(1)
  print(pi, 4, 4, 7)
  local spacing = width / #history
  line(0, height / 2, 0, height / 2, 1) -- initial start of lines
  color(12)
  for i = 1, #history do
    local x = i * spacing
    local y = math_map(history[i], min_y, max_y, height, 0)
    line(x, y)
  end
  local pi_y = math_map(3.1415, min_y, max_y, height, 0)
  line(0, pi_y, width, pi_y, 11)
end
