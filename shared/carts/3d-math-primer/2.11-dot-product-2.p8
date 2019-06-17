pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this cart demonstrates using the dot product
-- to separate a vector into components that are
-- parallel and perpendicular to another vector.
-- see recalculate_dot().
--
-- this is figure 2.24 in the book.

#include lib/vector2d.p8:0

g = { }

function _init()
  camera(-64, -64)
  g.origin = vector2d_type:new()
  g.zoom_origin = vector2d_type:new(45, 45)
  reset_v1()
  g.v2 = vector2d_type:new(rnd_32_64(), rnd_32_64())
  g.v2hat = vector2d_type:new()
  g.parallel = vector2d_type:new()
  g.parallel_hat = vector2d_type:new()
  g.perpendicular = vector2d_type:new()
  g.perpendicular_hat = vector2d_type:new()
end

function reset_v1()
  local v1 = vector2d_type:new(rnd_32_64(), rnd_32_64())
  g.v1hat = vector2d_type.random_vector():normalize()
end

function _update60()
  if (btnp(5)) reset_v1()
  if (btn(0)) g.v2.x -= 1
  if (btn(1)) g.v2.x += 1
  if (btn(2)) g.v2.y -= 1
  if (btn(3)) g.v2.y += 1
  g.v2:copy_to_ref(g.v2hat)
  g.v2hat:normalize()
  recalculate_dot()
end

function recalculate_dot()
  g.dot_product_v1_unit = vector2d_type.dot(g.v1hat, g.v2)
  -- parallel is the dot product of (v1-hat and v2) * v1-hat
  g.v1hat:copy_to_ref(g.parallel)
  g.parallel:mult(g.dot_product_v1_unit)
  g.parallel:copy_to_ref(g.parallel_hat)
  g.parallel_hat:normalize()
  -- perpendicular is v2 - parallel
  g.v2:copy_to_ref(g.perpendicular)
  g.perpendicular:sub(g.parallel)
  g.perpendicular:copy_to_ref(g.perpendicular_hat)
  g.perpendicular_hat:normalize()
end

function _draw()
  cls(1)
  draw_positive_x_axis()
  draw_parallel()
  draw_perpendicular()
  draw_v2()
  draw_v1hat()
  draw_zoom()
  local parallel_coordinates = '(' .. flr(g.parallel.x) .. ', ' .. flr(g.parallel.y) .. ')'
  local perpendicular_coordinates = '(' .. flr(g.perpendicular.x) .. ', ' .. flr(g.perpendicular.y) .. ')'
  print('dot product * v1hat: ' .. g.dot_product_v1_unit, 4 - 64, 4 - 64 + 0,  7)
  print('parallel     :' .. parallel_coordinates,      4 - 64, 4 - 64 + 7,  9)
  print('perpendicular:' .. perpendicular_coordinates,      4 - 64, 4 - 64 + 14, 10)
  print('arrow keys to move v2',                          4 - 64, 4 + 64 - 21, 7)
  print('x to randomize v1hat',                           4 - 64, 4 + 64 - 14, 7)
end

function draw_positive_x_axis()
  line(g.origin.x, g.origin.y, g.origin.x + 64, g.origin.y, 7)
end

function draw_parallel()
  line(g.origin.x, g.origin.y, g.parallel.x, g.parallel.y, 9)
end

function draw_perpendicular()
  line(g.origin.x, g.origin.y, g.perpendicular.x, g.perpendicular.y, 10)
end

function draw_v1hat()
  line(g.origin.x, g.origin.y, g.v1hat.x * 2, g.v1hat.y * 2, 11)
end

function draw_zoom()
  -- zoom circles and line
  circ(g.origin.x, g.origin.y, 3, 5)
  circ(g.zoom_origin.x, g.zoom_origin.y, 16, 5)
  line(g.origin.x + 3, g.origin.y + 3, g.zoom_origin.x - 12, g.zoom_origin.y - 12, 5)
  -- positive x-axis
  line(g.zoom_origin.x, g.zoom_origin.y, g.zoom_origin.x + 16, g.zoom_origin.y, 7)
  -- v1hat
  line(g.zoom_origin.x, g.zoom_origin.y,
       g.zoom_origin.x + g.v1hat.x * 15, g.zoom_origin.y + g.v1hat.y * 15,
       11)
  -- parallel
  line(g.zoom_origin.x, g.zoom_origin.y,
       g.zoom_origin.x + g.parallel_hat.x * 15, g.zoom_origin.y + g.parallel_hat.y * 15,
       9)
  -- perpendicular
  line(g.zoom_origin.x, g.zoom_origin.y,
       g.zoom_origin.x + g.perpendicular_hat.x * 15, g.zoom_origin.y + g.perpendicular_hat.y * 15,
       10)
  -- v2hat
  line(g.zoom_origin.x, g.zoom_origin.y,
       g.zoom_origin.x + g.v2hat.x * 15, g.zoom_origin.y + g.v2hat.y * 15,
       12)
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
