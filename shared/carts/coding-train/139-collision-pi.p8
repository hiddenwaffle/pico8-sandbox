pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- cannot get too many digits, probably due to
-- the low resolution of the numbers in pico-8.
-- https://www.youtube.com/watch?v=PoW8g67XNxA

-- based on:
-- https://www.youtube.com/watch?v=HEfHFsfGXjs
-- https://www.youtube.com/watch?v=jsYwFizhncE

local width
local height
local count = 0
local digits = 2 -- as in, digits of pi to compute
local block1
local block2
local time_steps = 10

function _init()
  camera(0, 1)
  width = 128
  height = 128
  count = 0
  block1 = block_type:new(33, 7, 1, 0)
  local m2 = 100 ^ (digits - 1)
  block2 = block_type:new(67, 50, m2, -1 / time_steps)
end

function _update60()
  for i = 1, time_steps do
    if (block1:collide(block2)) then
      local v1 = block1:bounce(block2)
      local v2 = block2:bounce(block1)
      block1.v = v1
      block2.v = v2
      sfx(0)
      count += 1
    end
    if block1:hit_wall() then
      block1:reverse()
      sfx(0)
      count += 1
    end
    block1:update()
    block2:update()
  end
end

function _draw()
  cls(1)
  block1:show()
  block2:show()
  print(count, 4, 4, 7)
end

-->8

block_type = { }

function block_type:new(x, w, m, v)
  local o = {
    x = x,
    y = height - w,
    w = w,
    v = v,
    m = m
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function block_type:hit_wall()
  return self.x <= 0
end

function block_type:reverse()
  self.v *= -1
end

function block_type:collide(other)
  return not (self.x + self.w < other.x or
              self.x > other.x + other.w)
end

-- formula for an elastic collision,
-- follows the conservation of momentum and
-- conservation of energy
function block_type:bounce(other)
  local sum_m = self.m + other.m
  local new_v = (self.m - other.m) / sum_m * self.v
  new_v += 2 * other.m / sum_m * other.v
  return new_v
end

function block_type:update()
  self.x += self.v
end

function block_type:show()
  rect(self.x, self.y,
       self.x + self.w, self.y + self.w,
       7)
end

__sfx__
000100001805030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
