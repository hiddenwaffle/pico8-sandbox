pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this is very different from the video because
-- p8 does not have a lot of the functions used

function _init()
  t = 0
  amplitude = 32
  angle = 0
  x = 0
  camera(-64, -64)
end

function _update60()
  angle += 0.025
  x = amplitude * sin(angle)
end

function _draw()
  cls(1)
  line(0, 0, x, 0)
  circ(x, 0, 10)
end
