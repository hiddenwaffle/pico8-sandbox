pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- interlude
-- based on:
-- http://danlucraft.com/blog/2016/12/3d-from-scratch-day-1/

g = { }

function _init()
  g.screen_dist = 100
  g.cube = {
    { x =  50, y =  50, z = 250 },
    { x =  50, y =  50, z = 150 },
    { x =  50, y = -50, z = 250 },
    { x = -50, y =  50, z = 250 },
    { x =  50, y = -50, z = 150 },
    { x = -50, y =  50, z = 150 },
    { x = -50, y = -50, z = 250 },
    { x = -50, y = -50, z = 150 },
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
  g.transform = { x = 0, y = 0, z = 0 }
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
    draw_line_3d(new_p1, new_p2)
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
