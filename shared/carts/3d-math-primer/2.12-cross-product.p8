pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/vector3d.p8:0

-- this "helps" visualize the cross product vector.
-- warps the vectors around to give it some perpsective through animation,
-- in lieu of real rotations and transformations.

g = { }

function _init()
  camera(-64, -64)
  g.vs = { }
  reset()
end

function reset()
  g.diff = 0.3 * rndsign()
  g.vs[1] = vector3d_type:new(rnd48(), rnd48(), rnd48())
  g.vs[2] = vector3d_type:new(rnd48(), rnd48(), rnd48())
  g.vs[3] = vector3d_type:new()
  g.vs[4] = vector3d_type:new()
end

function _update60()
  if btnp(5) then
    reset()
  end
  g.vs[1].x += g.diff
  g.vs[1].y -= g.diff
  g.vs[1].z += g.diff
  g.vs[2].x += g.diff
  g.vs[2].y -= g.diff
  g.vs[2].z += g.diff
  vector3d_type.cross_to_ref(g.vs[1], g.vs[2], g.vs[3]) -- v1 x v2
end

function _draw()
  cls(1)
  for i = 1, #g.vs do
    local v = g.vs[i]
    local color = color_for(i)
    local z = v.z
    if (z == 0) z = 0.001 -- bandaid
    local x = v.x / z
    local y = v.y / z
    line(0, 0, x * 32, y * 32, color)
    if i == 1 then -- v1
      print('v1', x * 32 + 2, y * 32 + 2, 4)
    elseif i == 2 then -- v2
      print('v2', x * 32 + 2, y * 32 + 2, 3)
    elseif i == 3 then -- normal
      print('n', x * 32 + 2, y * 32 + 2, 13)
    end
  end
  print('press x to randomize', 4 - 64, 4 - 64, 7)
end

function color_for(index)
  if (index == 1) return 9
  if (index == 2) return 11
  if (index == 3) return 12
end

-->8

function rnd48()
  return 24 - flr(rnd(48))
end

function rndsign()
  if rnd(1) < 0.5 then
    return -1
  else
    return 1
  end
end
