pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this cart demonstrates the geometric interpretation
-- of the dot product. it projects v2 onto v1 with a
-- pink vector. see recalculate_dot().

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
  g.v1hat = g.v1:copy():normalize()
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
  g.dot_product_v1_unit = vector2d_type.dot(g.v1hat, g.v2)
  -- also recalculate projection from dot.
  -- this is the dot product * a-hat,
  -- i.e. a but with the dot product as the magnitude
  g.projection.x = g.v1.x
  g.projection.y = g.v1.y
  g.projection:set_mag(g.dot_product_v1_unit)
end

function _draw()
  cls(1)
  draw_positive_x_axis()
  draw_v1()
  draw_v2()
  draw_projection()
  print('dot product        : ' .. g.dot_product,         4 - 64, 4 - 64,      7)
  print('dot product * v1hat: ' .. g.dot_product_v1_unit, 4 - 64, 4 - 64 + 7,  14)
  print('v1 magnitude       : ' .. g.v1:magnitude(),      4 - 64, 4 - 64 + 14, 11)
  print('v2 magnitude       : ' .. g.v2:magnitude(),      4 - 64, 4 - 64 + 21, 12)
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

function draw_projection()
  line(g.origin.x, g.origin.y, g.projection.x, g.projection.y, 14)
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
