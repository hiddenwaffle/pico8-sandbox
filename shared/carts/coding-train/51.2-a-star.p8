pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- diagonal movement is off by default,
-- flip g.diagonals_on = true in the init function
-- to allow it.

-- coding challenge #51.1, #51.2
-- https://www.youtube.com/watch?v=aKYlikFAV4k
-- https://www.youtube.com/watch?v=EaZxUCWAjb0

#include lib/table.p8:0

g = { }

function _init()
  g.diagonals_on = false -- toggle to turn on/off moving diagonally
  g.cols = 25
  g.rows = 25
  g.w = flr(128 / g.cols)
  g.h = flr(128 / g.rows)
  g.path = { }
  g.grid = { }
  -- making a 2d array
  for i = 1, g.cols do
    g.grid[i] = { }
    for j = 1, g.rows do
      g.grid[i][j] = spot_type:new(i, j)
    end
  end
  -- link neighbors together
  for i = 1, g.cols do
    for j = 1, g.rows do
      g.grid[i][j]:add_neighbors(grid)
    end
  end
  g.open_set = { } -- "just got to a neighbor for the first time, add it to this table"
  g.closed_set = { }
  g.start = g.grid[1][1]
  g.finish = g.grid[g.cols][g.rows]
  add(g.open_set, g.start)
  g.done = false
  g.no_solution = false
  -- build a vertical wall in the middle
  local wall_top = flr((g.rows / 2) - (g.rows / 4))
  local wall_bottom = wall_top + flr(g.rows / 2)
  for j = wall_top, wall_bottom do
    g.grid[flr(g.cols / 2)][j].wall = true
  end
end

function _update60()
  if #g.open_set == 0 or g.done then
    return
  end
  local current = g.open_set[1]
  for spot in all(g.open_set) do -- it will compare against itself but that's ok
    if spot.f < current.f then
      current = spot
    end
  end
  if current == g.finish then
    g.done = true
  end
  del(g.open_set, current)
  add(g.closed_set, current)
  for neighbor in all(current.neighbors) do
    if not table_contains(g.closed_set, neighbor) and
       not neighbor.wall then
      local tentative_g = current.g + 1
      local new_path = false
      if table_contains(g.open_set, neighbor) then
        if tentative_g < neighbor.g then
          neighbor.g = tentative_g
          new_path = true
        end
      else
        neighbor.g = tentative_g
        new_path = true
        add(g.open_set, neighbor)
      end
      if new_path then
        neighbor.h = heuristic(neighbor, g.finish) -- "make an educated guess for distance between here and the end"
        neighbor.f = neighbor.g + neighbor.h
        neighbor.previous = current
      end
    end
  end
  -- recalculate the path up until now, for visualization
  g.path = { }
  local temp = current
  add(g.path, temp)
  while temp.previous do
    add(g.path, temp.previous)
    temp = temp.previous
  end
end

function _draw()
  cls(1)
  for spot in all(g.closed_set) do
    spot:show(2)
  end
  for spot in all(g.open_set) do
    spot:show(11)
  end
  -- grid lines
  for i = 1, g.cols do
    for j = 1, g.rows do
      g.grid[i][j]:show()
    end
  end
  for spot in all(g.path) do
    if g.done and flr(t()) % 2 == 0 then
      spot:show(10)
    else
      spot:show(12)
    end
  end
  -- are we done?
  if #g.open_set == 0 and not g.done then
    rectfill(0, 0, 128, 16, 0)
    print('no solution', 4, 4, 7)
    return
  end
  if g.done then
    -- todo: maybe not do anything
    -- rectfill(0, 0, 128, 16, 0)
    -- print('done!', 4, 4, 7)
    -- return
  end
end

-->8

spot_type = { }

function spot_type:new(i, j)
  local o = {
    i = i,
    j = j,
    f = 0,
    g = 0,
    h = 0,
    neighbors = { },
    previous = nil,
    wall = false
  }
  if rnd(1) < 0.2 and not (i == 1 and j == 1) and not (i == g.cols and j == g.rows) then
    o.wall = true
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function spot_type:show(col)
  if self.wall then
    col = 6
  end
  local x1 = (self.i - 1) * g.w
  local y1 = (self.j - 1) * g.w
  if col then
    rectfill(x1, y1,
             x1 + g.w, y1 + g.w,
             col)
  end
  -- also give it a fun outline why not
  rect(x1, y1,
       x1 + g.w, y1 + g.w,
       7)
end

function spot_type:add_neighbors(grid)
  local i = self.i
  local j = self.j
  if i > 1 then
    add(self.neighbors, g.grid[i - 1][j])
  end
  if i < g.cols then
    add(self.neighbors, g.grid[i + 1][j])
  end
  if j > 1 then
    add(self.neighbors, g.grid[i][j - 1])
  end
  if j < g.rows then
    add(self.neighbors, g.grid[i][j + 1])
  end
  -- these do diagonals
  if g.diagonals_on then
    if i > 1 and j > 1 then
      add(self.neighbors, g.grid[i - 1][j - 1])
    end
    if i < g.cols and j > 1 then
      add(self.neighbors, g.grid[i + 1][j - 1])
    end
    if i < 1 and j < g.rows then
      add(self.neighbors, g.grid[i - 1][j + 1])
    end
    if i < g.cols and j < g.rows then
      add(self.neighbors, g.grid[i + 1][j + 1])
    end
  end
end

-->8

function heuristic(a, b)
  local d = dist_16bit(a.i, a.j, b.i, b.j) -- "euclidian"
  -- local d = abs(a.i - b.i) + abs(a.j - b.j) -- "manhattan"
  return d
end

-- taken from vector2d lib
function dist_16bit(x1, y1, x2, y2)
  local x1 *= 0.001
  local x2 *= 0.001
  local y1 *= 0.001
  local y2 *= 0.001
  local a = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
  return a / 0.001
end
