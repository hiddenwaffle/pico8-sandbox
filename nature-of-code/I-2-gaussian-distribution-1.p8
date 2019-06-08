pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
end

function _update60()
end

function _draw()
  cls(1)
  local h = next_gaussian() -- mean = 0 and std dev = 1
  -- now stretch and move h
  h *= 5
  h = h + 50
  circfill(64, 64, h, 0)
end

-->8

-- based on:
-- https://www.alanzucconi.com/2015/09/16/how-to-sample-from-a-gaussian-distribution/
-- a gaussian random number with a mean of 0 and std dev = 1
function next_gaussian()
  local v1 = 2 * rnd(1) - 1
  local v2 = 2 * rnd(1) - 1
  local s = v1 * v1 + v2 * v2
  while s >= 1 or s == 0 do
    v1 = 2 * rnd(1) - 1
    v2 = 2 * rnd(1) - 1
    s = v1 * v1 + v2 * v2
  end
  s = sqrt((-2 * ln(s)) / s)
  return v1 * s
end

-- rough implementation based on:
-- https://stackoverflow.com/a/21809751
function ln(a)
  local n = 1
  for i = 1, 11 do -- cannot do more without large precision loss?
    n *= 2
    a = sqrt(a) -- precision loss probably due to this converging quickly to 1
  end
  return n * (a - 1)
end
-- uncomment below to test ln():
-- cls()
-- print('ln(1)    0      ' .. ln(1))
-- print('ln(2)    0.693  ' .. ln(2))
-- print('ln(2.25) 0.810  ' .. ln(2.25))
-- print('ln(2.71) 1      ' .. ln(2.71))
-- print('ln(3)    1.098  ' .. ln(3))
-- print('ln(10)   2.302  ' .. ln(10))
-- print('ln(100)  4.605  ' .. ln(100))

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
