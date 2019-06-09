pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this is very different from the video because
-- p8 does not have a lot of the functions used

function _init()
  r = 30
  a = 0
  a_vel = 0
  a_acc = 0.0001
  camera(-64, -64)
end

function _update60()
  a_vel += a_acc
  a += a_vel
  a_vel = mid(a_vel, 0, 0.5)
end

function _draw()
  cls(1)
  local x = r * cos(a)
  local y = r * sin(a)
  circ(x, y, 6, 11)
  line(0, 0, x, y, 7)
end
