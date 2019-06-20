pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #81.1
-- https://www.youtube.com/watch?v=u2D4sxh3MTs

#include lib/vector2d.p8:0
#include lib/shape2d.p8:0

g = { }

function _init()
  camera(-64, -64)
  g.cir_path = { }
  g.tri_path = { }
  g.spacing = 10
  local radius = 50
  local start_a = 0
  local end_a = 120
  local start_v = polar_to_cartesian(radius, start_a / 360)
  local end_v   = polar_to_cartesian(radius, end_a / 360)
  for a = 0, 360, g.spacing do
    local cv = polar_to_cartesian(radius, a / 360)
    add(g.cir_path, cv)
    local amt = (a % 120) / (end_a - start_a)
    local tv = vector2d_type.lerp(start_v, end_v, amt)
    add(g.tri_path, tv)
    if (a + g.spacing) % 120 == 0 then
      start_a += 120
      end_a += 120
      start_v = polar_to_cartesian(radius, start_a / 360)
      end_v   = polar_to_cartesian(radius, end_a / 360)
    end
  end
  g.theta = 0
end

function _update60()
  g.theta += 0.01
end

function _draw()
  cls(1)
  local amt = (sin(g.theta) + 1) / 2
  local mor_path = { }
  for i = 1, #g.tri_path do
    local cv = g.cir_path[i]
    local tv = g.tri_path[i]
    v = vector2d_type.lerp(cv, tv, amt)
    add(mor_path, v)
  end
  shape2d(mor_path, 7)
end

-- be sure to convert from 0..360 to 0..1
function polar_to_cartesian(r, angle)
  return vector2d_type:new(r * cos(angle), r * sin(angle))
end
