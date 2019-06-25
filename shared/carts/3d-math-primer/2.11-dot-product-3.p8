pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this cart demonstrates the relationship between
-- the dot product and cosine.
-- this is figure 2.25 and equations 2.4 and 2.5 in the book.
-- see recalculate_dot() for cosine calculation.

-- it can be helpful to know that dotting two unit vectors
-- results in a value less than 1 and is the cosine of
-- the angle between the vectors.
-- if the vectors are scaled, this value scales too.
-- therefore you can get the cosine of any two vectors
-- by normalizing them first.

#include lib/math.p8:0
#include lib/vector2d.p8:0

g = { }

function _init()
  camera(-64, -64)
  g.origin = vector2d_type:new()
  reset_v1()
  g.v2 = vector2d_type:new(rnd_32_64(), rnd_32_64())
  g.projection = vector2d_type:new()
end

function reset_v1()
  g.v1 = vector2d_type:new(rnd_32_64(), rnd_32_64())
end

function _update60()
  if (btnp(5)) reset_v1()
  if (btn(0)) g.v2.x -= 1
  if (btn(1)) g.v2.x += 1
  if (btn(2)) g.v2.y -= 1
  if (btn(3)) g.v2.y += 1
  recalculate_dot()
end

function recalculate_dot()
  g.dot_product = vector2d_type.dot(g.v1, g.v2)
  -- also recalculate projection from dot.
  -- this is the dot product * a-hat,
  -- i.e. a but with the dot product as the magnitude
  g.projection.x = g.v1.x
  g.projection.y = g.v1.y
  -- calculate cosine and angle (old way, deprecated)
  -- g.cosine = g.dot_product / (g.v1:magnitude() * g.v2:magnitude())
  -- g.angle = vector2d_type.acos(g.cosine)
  -- use angle_between instead (new way)
  g.angle = vector2d_type.angle_between(g.v1, g.v2)
  g.cosine = cos(g.angle) -- not really necessary anymore
  -- see vector2d_type.angle_between() for library implementation
  -- of the above two lines
end

function _draw()
  cls(1)
  draw_positive_x_axis()
  draw_v1()
  draw_v2()
  print('dot product: ' .. g.dot_product,         4 - 64, 4 - 64,       7)
  print('||v1||:      ' .. g.v1:magnitude(),      4 - 64, 4 - 64 +  7, 11)
  print('||v2||:      ' .. g.v2:magnitude(),      4 - 64, 4 - 64 + 14, 12)
  print('cosine:      ' .. g.cosine,              4 - 64, 4 - 64 + 21,  7)
  print('angle:       ' .. g.angle,               4 - 64, 4 - 64 + 28,  7)
  print('arrow keys to move v2',                        4 - 64, 4 + 64 - 21, 7)
  print('x to randomize v1',                            4 - 64, 4 + 64 - 14, 7)
end

function draw_positive_x_axis()
  line(g.origin.x, g.origin.y, g.origin.x + 64, g.origin.y, 7)
end

function draw_v1()
  line(g.origin.x, g.origin.y, g.v1.x, g.v1.y, 11)
  print('v1', g.v1.x + 2, g.v1.y, 3)
end

function draw_v2()
  line(g.origin.x, g.origin.y, g.v2.x, g.v2.y, 12)
  print('v2', g.v2.x + 2, g.v2.y, 13)
end

-->8

-- return a random integer in [32, 64] or [-64, -32]
function rnd_32_64()
  local sign = rnd(1)
  if sign < 0.5 then
    return -64 + flr(rnd(33))
  else
    return 64 - flr(rnd(33))
  end
end
