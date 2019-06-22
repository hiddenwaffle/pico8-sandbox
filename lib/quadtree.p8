pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- todo: point and rectangle types are named to generically

point_type = { }

function point_type:new(x, y, userdata)
  local o = {
    x = x,
    y = y,
    userdata = userdata
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

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

function rectangle_type:intersects(range)
  return not (range.x - range.w  > self.x + self.w or
              range.x + range.w  < self.x - self.w or
              range.y - range.h  > self.y + self.h or
              range.y + range.h  < self.y - self.h)
end

quad_tree_type = { }

function quad_tree_type:new(boundary, n)
  local o = {
    boundary = boundary,
    capacity = n,
    points = { },
    divided = false,
    color = quad_tree_next_color()
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

function quad_tree_type:query(range, found)
  if (not found) found = { }
  if not self.boundary:intersects(range) then
    return found
  else
    for p in all(self.points) do
      if range:contains(p) then
        add(found, p)
      end
    end
    if self.divided then
      self.northwest:query(range, found)
      self.northeast:query(range, found)
      self.southwest:query(range, found)
      self.southeast:query(range, found)
    end
  end
  return found
end

function quad_tree_type:show()
  rect(self.boundary.x,
       self.boundary.y,
       self.boundary.x + self.boundary.w,
       self.boundary.y + self.boundary.h,
       7)
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

g_color = 7
function quad_tree_next_color()
  g_color += 1
  if g_color == 1 or g_color == 7 or g_color == 1 then
    g_color += 1
  elseif g_color == 16 then
    g_color = 0
  end
  return g_color
end
