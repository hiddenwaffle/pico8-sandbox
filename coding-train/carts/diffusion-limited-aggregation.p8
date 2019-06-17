pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #34
-- https://www.youtube.com/watch?v=Cl_Gjj80gPE

#include lib/vector2d.p8:0

g = { }

function _init()
  g.r = 3
  g.r_sq_2x = g.r * g.r * 2
  g.tree = { }
  add(g.tree, walker_type:new(64, 64, true))
  g.tree_bounds = { -- optimization
    x1 = 64 - g.r,
    y1 = 64 - g.r,
    x2 = 64 + g.r,
    y2 = 64 + g.r
  }
  g.walkers = { }
  g.max_tree_size = 250
  g.max_walkers = 10
  for i = 1, g.max_walkers do
    add(g.walkers, walker_type:new())
  end
  g.iterations = 1000
end

function _update60()
  if (#g.tree >= g.max_tree_size) return
  for n = 1, g.iterations do
    for walker in all(g.walkers) do
      walker:walk()
      if walker:check_stuck(g.tree) then
        add(g.tree, walker)
        del(g.walkers, walker)
      end
    end
  end
  while #g.walkers < g.max_walkers do
    add(g.walkers, walker_type:new())
  end
end

function _draw()
  cls(1)
  for branch in all(g.tree) do
    branch:show()
  end
  for walker in all(g.walkers) do
    walker:show()
  end
  -- debug:
  rect(g.tree_bounds.x1, g.tree_bounds.y1,
       g.tree_bounds.x2, g.tree_bounds.y2,
       13)
  print('cpu: ' .. stat(1) .. ', tree: ' .. #g.tree, 4, 4, 12)
end

-->8

walker_type = { }

function walker_type:new(x, y, stuck)
  local o = {
    stuck = stuck
  }
  if x and y then
    o.pos = vector2d_type:new(x, y)
  else
    o.pos = random_point(x, y)
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function walker_type:walk()
  local vel = vector2d_type.random_vector()
  self.pos:add(vel)
  self.pos.x = mid(self.pos.x, 0, 127)
  self.pos.y = mid(self.pos.y, 0, 127)
end

function walker_type:check_stuck(others)
  if (not within_tree_bounds(self.pos.x, self.pos.y)) return false
  local r_x3 = g.r * 3
  for other in all(others) do
    -- local d = dist_sq(self.pos, other.pos) -- vector2d_type.dist_16bit(self.pos, other.pos)
    local dx = other.pos.x - self.pos.x
    local dy = other.pos.y - self.pos.y
    -- todo: way to prevent multiplication if not necessary?
    local d_sq = dx * dx + dy * dy
    if d_sq < g.r_sq_2x then
      update_tree_bounds(self.pos.x, self.pos.y)
      self.stuck = true
      return true
    end
  end
  return false
end

function within_tree_bounds(x, y)
  local b = g.tree_bounds
  return x >= b.x1 and x <= b.x2 and y >= b.y1 and y <= b.y2
end

function update_tree_bounds(x, y)
  local bounds = g.tree_bounds
  if x - g.r < bounds.x1 then
    bounds.x1 = x - g.r
  elseif x + g.r > bounds.x2 then
    bounds.x2 = x + g.r
  end
  if y - g.r < bounds.y1 then
    bounds.y1 = y - g.r
  elseif y + g.r > bounds.y2 then
    bounds.y2 = y + g.r
  end
end

function walker_type:show()
  local color = 7
  if (self.stuck) color = 11
  circfill(self.pos.x, self.pos.y, g.r, color)
  circ(self.pos.x, self.pos.y, g.r, 3)
end

function random_point(x, y)
  -- vector2d_type:new(x or flr(rnd(127)), y or flr(rnd(127)))
  local i = flr(rnd(4))
  if i == 0 then
    return vector2d_type:new(flr(rnd(127)), 0)
  elseif i == 1 then
    return vector2d_type:new(flr(rnd(127)), 127)
  elseif i == 2 then
    return vector2d_type:new(0, flr(rnd(127)))
  else
    return vector2d_type:new(127, flr(rnd(127)))
  end
end

-- to help speed things up by not square rooting
function dist_sq(a, b)
end
