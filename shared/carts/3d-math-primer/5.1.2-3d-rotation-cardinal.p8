pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/matrix.p8
#include lib/vector3.p8

#include lib/math.p8:0

g = { }

function _init()
  g.angle = 0.10
  g.mrot = matrix_type:new(3, 3)
  g.rotation_type = 0
  g.scratch = vector3_type:new()
  g.cube = {
    -- main verticies
    vector3_type:new( 0.25,  0.25, -0.25),
    vector3_type:new( 0.25, -0.25, -0.25),
    vector3_type:new(-0.25, -0.25, -0.25),
    vector3_type:new(-0.25,  0.25, -0.25),
    vector3_type:new( 0.25,  0.25,  0.25),
    vector3_type:new( 0.25, -0.25,  0.25),
    vector3_type:new(-0.25, -0.25,  0.25),
    vector3_type:new(-0.25,  0.25,  0.25)
  }
end

function _update60()
  if btnp(5) then
    g.rotation_type += 1
    if (g.rotation_type >= 3) g.rotation_type = 0
    g.mrot:reset()
  end
  g.angle += 0.005
  if g.rotation_type == 0 then -- x-axis
    g.mrot[1][1] =  1
    g.mrot[2][2] =  cos(g.angle) ; g.mrot[2][3] = -sin(g.angle)
    g.mrot[3][2] =  sin(g.angle) ; g.mrot[3][3] =  cos(g.angle)
  elseif g.rotation_type == 1 then -- y-axis
    g.mrot[1][1] =  cos(g.angle) ; g.mrot[1][2] = 0 ; g.mrot[1][3] = sin(g.angle)
    g.mrot[2][1] =             0 ; g.mrot[2][2] = 1 ; g.mrot[2][3] =            0
    g.mrot[3][1] = -sin(g.angle) ; g.mrot[3][2] = 0 ; g.mrot[3][3] = cos(g.angle)
  elseif g.rotation_type == 2 then -- z-axis
    g.mrot[1][1] =  cos(g.angle) ; g.mrot[1][2] = -sin(g.angle) ; g.mrot[1][3] = 0
    g.mrot[2][1] =  sin(g.angle) ; g.mrot[2][2] =  cos(g.angle) ; g.mrot[2][3] = 0
    g.mrot[3][1] =             0 ; g.mrot[3][2] = 0             ; g.mrot[3][3] = 1
  end
end

function _draw()
  cls(1)
  -- grid
  for x = -2, 2 do
    draw_line(x, -2, x, 2, 5)
  end
  for y = -1, 4 do
    draw_line(-2, y, 2, y, 5)
  end
  -- x-y axes
  draw_line(0, -2, 0, 2, 7)
  draw_line(-2, 0, 2, 0, 7)
  -- cube points
  for v in all(g.cube) do
    -- determine final points from rotation
    vector3_type.transform_to_ref(v, g.mrot, g.scratch)
    -- rudimentary projection
    if (v.z == 0) v.z = 0.001
    draw_point(g.scratch.x / g.scratch.z,
               g.scratch.y / g.scratch.z,
               14)
  end
end

function draw_line(x1, y1, x2, y2, col)
  local px1 = math_map(x1, -2, 2, 0, 127)
  local py1 = math_map(y1, -2, 2, 127, 0)
  local px2 = math_map(x2, -2, 2, 0, 127)
  local py2 = math_map(y2, -2, 2, 127, 0)
  line(px1, py1, px2, py2, col)
end

function draw_point(x, y, col)
  local px = math_map(x, -2, 2, 0, 127)
  local py = math_map(y, -2, 2, 127, 0)
  pset(px, py, col)
end
