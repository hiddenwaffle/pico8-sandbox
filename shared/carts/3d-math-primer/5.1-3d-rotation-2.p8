pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- interlude
-- based on:
-- http://danlucraft.com/blog/2016/12/3d-from-scratch-day-1/
-- got to the view plane check on day 2
-- http://danlucraft.com/blog/2016/12/3d-from-scratch-day-2/
-- but stopped because it wasn't working, possibly due to > 16-bit numbers?

#include lib/vector3.p8

g = { }

function _init()
  g.screen_dist = 100
  g.screen_coords = {
    vector3_type:new( 128 / 2,  128 / 2, screen_dist),
    vector3_type:new(-128 / 2,  128 / 2, screen_dist), -- bottom left
    vector3_type:new(-128 / 2, -128 / 2, screen_dist), -- top left
    vector3_type:new( 128 / 2, -128 / 2, screen_dist)  -- top right
  }
  g.view_plane_normals = {
    vector3_type.cross(g.screen_coords[1], g.screen_coords[2]), -- bottom plane
    vector3_type.cross(g.screen_coords[2], g.screen_coords[3]), -- left plane
    vector3_type.cross(g.screen_coords[3], g.screen_coords[4]), -- top plane
    vector3_type.cross(g.screen_coords[4], g.screen_coords[1])  -- right plane
  }
  g.cube = {
    vector3_type:new( 50,  50, 250),
    vector3_type:new( 50,  50, 150),
    vector3_type:new( 50, -50, 250),
    vector3_type:new(-50,  50, 250),
    vector3_type:new( 50, -50, 150),
    vector3_type:new(-50,  50, 150),
    vector3_type:new(-50, -50, 250),
    vector3_type:new(-50, -50, 150)
  }
  g.edges = {
    {1, 2},
    {1, 3},
    {1, 4},
    {2, 5},
    {2, 6},
    {3, 5},
    {3, 7},
    {4, 6},
    {4, 7},
    {5, 8},
    {6, 8},
    {7, 8}
  }
  g.transform = vector3_type:new()
end

function _update60()
  if (btn(0)) g.transform.x -= 5
  if (btn(1)) g.transform.x += 5
  if (btn(2)) g.transform.z += 5
  if (btn(3)) g.transform.z -= 5
end

function _draw()
  cls(1)
  for j = 1, #g.edges do
    local p1 = g.cube[g.edges[j][1]]
    local p2 = g.cube[g.edges[j][2]]
    local new_p1 = {
      x = p1.x + g.transform.x,
      y = p1.y + g.transform.y,
      z = p1.z + g.transform.z
    }
    local new_p2 = {
      x = p2.x + g.transform.x,
      y = p2.y + g.transform.y,
      z = p2.z + g.transform.z
    }
    if is_point_in_view(new_p1) and
       is_point_in_view(new_p2) then
      draw_line_3d(new_p1, new_p2)
    end
  end
end

function draw_line_3d(p1, p2)
  local x1 = flr(p1.x * (g.screen_dist / p1.z))
  local y1 = flr(p1.y * (g.screen_dist / p1.z))
  local x2 = flr(p2.x * (g.screen_dist / p2.z))
  local y2 = flr(p2.y * (g.screen_dist / p2.z))
  line(x1 + 128 / 2, y1 + 128 / 2,
       x2 + 128 / 2, y2 + 128 / 2,
       7)
end

function draw_point_3d(p)
  local x = flr(p.x * (g.screen_dist / p.z))
  local y = flr(p.y * (g.screen_dist / p.z))
  pset(x + 128 / 2, y + 128 / 2, 7)
end

function is_point_in_view(p)
  -- for view_plane_normal in all(g.view_plane_normals) do
  --   if (vector3_type.dot_16bit(p, view_plane_normal) < 0) return false
  -- end
  for i = 1, #g.view_plane_normals do
    if (vector3_type.dot_16bit(p, g.view_plane_normals[i]) < 0) return false
  end
  return true
end

-- monkeypatch <--------- !!!!!
function vector3_type.dot_16bit(u, v)
  local scale = 0.01
  local ux = u.x * scale
  local uy = u.y * scale
  local uz = u.z * scale
  local vx = v.x * scale
  local vy = v.y * scale
  local vz = v.z * scale
  -- todo: i don't know if this is what should actually happen
  return (ux * vx + uy * vy + uz * vz)
end
