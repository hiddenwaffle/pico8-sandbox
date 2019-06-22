pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #98.1
-- https://www.youtube.com/watch?v=OJxEcs0w_kE

g = { }

function _init()
  g.mouse = { x = 64, y = 64 }
  local boundary = rectangle_type:new(0, 0, 128, 128)
  g.qtree = quad_tree_type:new(boundary, 1)
end

function _update60()
  update_mouse()
end

function update_mouse()
  if (btn(0)) g.mouse.x -= 1
  if (btn(1)) g.mouse.x += 1
  if (btn(2)) g.mouse.y -= 1
  if (btn(3)) g.mouse.y += 1
  if btn(4) or btn(5) then
    local p = point_type:new(g.mouse.x, g.mouse.y)
    g.qtree:insert(p)
  end
end

function _draw()
  cls(1)
  g.qtree:show()
  print(stat(1), 4, 4, 8)
  draw_crosshair(g.mouse.x, g.mouse.y)
end

function draw_crosshair(x, y)
  pset(x - 1, y, 7)
  pset(x + 1, y, 7)
  pset(x, y - 1, 7)
  pset(x, y + 1, 7)
  pset(x - 2, y, 6)
  pset(x + 2, y, 6)
  pset(x, y - 2, 6)
  pset(x, y + 2, 6)
  pset(x - 3, y, 5)
  pset(x + 3, y, 5)
  pset(x, y - 3, 5)
  pset(x, y + 3, 5)
end

-->8

point_type = { }

function point_type:new(x, y)
  local o = {
    x = x,
    y = y
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-->8

rectangle_type = { }

function rectangle_type:new(x, y, w, h)
  local o = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function rectangle_type:contains(point)
  return point.x >= self.x          and
         point.x <= self.x + self.w and
         point.y >= self.y          and
         point.y <= self.y + self.h
end

-->8

quad_tree_type = { }

function quad_tree_type:new(boundary, n)
  local o = {
    boundary = boundary,
    capacity = n,
    points = { },
    divided = false,
    color = next_color()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function quad_tree_type:insert(point)
  if (not self.boundary:contains(point)) return false
  if #self.points < self.capacity then
    add(self.points, point)
    return true
  else
    if not self.divided then
      self:subdivide()
    end
    if (self.northeast:insert(point)) return true
    if (self.northwest:insert(point)) return true
    if (self.southeast:insert(point)) return true
    if (self.southwest:insert(point)) return true
  end
end

function quad_tree_type:subdivide()
  local x = self.boundary.x
  local y = self.boundary.y
  local w = self.boundary.w
  local h = self.boundary.h
  local half_w = flr(self.boundary.w / 2)
  local half_h = flr(self.boundary.h / 2)
  local nw = rectangle_type:new(x,          y, half_w,  half_h)
  local ne = rectangle_type:new(x + half_w, y, half_w,  half_h)
  local sw = rectangle_type:new(x,          y + half_h, half_w, half_h)
  local se = rectangle_type:new(x + half_w, y + half_h, half_w, half_h)
  self.northwest = quad_tree_type:new(nw, self.capacity)
  self.northeast = quad_tree_type:new(ne, self.capacity)
  self.southwest = quad_tree_type:new(sw, self.capacity)
  self.southeast = quad_tree_type:new(se, self.capacity)
  self.divided = true
end

function quad_tree_type:show()
  rect(self.boundary.x,
       self.boundary.y,
       self.boundary.x + self.boundary.w,
       self.boundary.y + self.boundary.h,
       self.color)
  if self.divided then
    self.northwest:show()
    self.northeast:show()
    self.southwest:show()
    self.southeast:show()
  end
  for point in all(self.points) do
    pset(point.x, point.y, self.color)
  end
end

-- for i = 1, 3617 do -- these 3 lines take up nearly 100% of cpu in 1 frame
--   g.x += g.x ^ g.x
-- end

-->8

g_color = 7
function next_color()
  g_color += 1
  if g_color == 1 or g_color == 7 then
    g_color += 1
  elseif g_color == 16 then
    g_color = 0
  end
  return g_color
end
