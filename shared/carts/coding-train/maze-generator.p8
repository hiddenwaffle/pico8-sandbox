pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #10
-- https://www.youtube.com/watch?v=HyK_Q5rrcr4

#include lib/stack.p8:0

g = { }

function _init()
  g.t = 0
  g.delay = 2
  camera(-4, -4)
  g.w = 8
  g.rows = flr(120 / g.w)
  g.cols = flr(120 / g.w)
  g.grid = { }
  for j = 1, g.rows do
    for i = 1, g.cols do
      local cell = cell_new(i, j)
      add(g.grid, cell)
    end
  end
  g.current = g.grid[1] -- top left
  g.current.visited = true
  g.stack = stack_new()
end

function _update60()
  g.t += 1
  if g.t >= g.delay then
    g.t = 0
    g.current.visited = true
    local next = cell_check_neighbors(g.current)
    if next then
      next.visited = true
      stack_push(g.stack, g.current)
      remove_walls(g.current, next)
      g.current = next
    elseif #g.stack > 0 then
      g.current = stack_pop(g.stack)
    end
  end
end

function _draw()
  cls()
  for cell in all(g.grid) do
    cell_show(cell)
  end
end

-->8

function cell_new(i, j)
  return {
    i = i,
    j = j,
    walls = { true, true, true, true }, -- top, right, bottom, left
    visited = false
  }
end

function cell_show(cell)
  local x = (cell.i - 1) * g.w
  local y = (cell.j - 1) * g.w
  if cell.visited then
    rectfill(x, y, x + g.w, y + g.w - 1, 1)
  end
  if cell == g.current then
    rectfill(x, y, x + g.w, y + g.w - 1, 12)
  end
  if (cell.walls[1]) line(x,       y,       x + g.w, y,       7) -- top
  if (cell.walls[2]) line(x + g.w, y,       x + g.w, y + g.w, 7) -- right
  if (cell.walls[3]) line(x + g.w, y + g.w, x,       y + g.w, 7) -- bottom
  if (cell.walls[4]) line(x,       y + g.w, x,       y,       7) -- left
  pset(x, y, 7) -- what's up with this?
end

function cell_check_neighbors(cell)
  local neighbors = { }
  local top     = g.grid[index(cell.i,     cell.j - 1)]
  local right   = g.grid[index(cell.i + 1, cell.j)]
  local bottom  = g.grid[index(cell.i,     cell.j + 1)]
  local left    = g.grid[index(cell.i - 1, cell.j)]
  if top and not top.visited then
    add(neighbors, top)
  end
  if right and not right.visited then
    add(neighbors, right)
  end
  if bottom and not bottom.visited then
    add(neighbors, bottom)
  end
  if left and not left.visited then
    add(neighbors, left)
  end
  if #neighbors > 0 then
    local r = flr(rnd(#neighbors)) + 1
    return neighbors[r]
  else
    return nil
  end
end

-->8

function remove_walls(a, b)
  local x = a.i - b.i
  if x == 1 then
    a.walls[4] = false
    b.walls[2] = false
  elseif x == -1 then
    a.walls[2] = false
    b.walls[4] = false
  end
  local y = a.j - b.j
  if y == 1 then
    a.walls[1] = false
    b.walls[3] = false
  elseif y == -1 then
    a.walls[3] = false
    b.walls[1] = false
  end
end

function index(i, j)
  if i < 1 or j < 1 or i > g.cols or j > g.rows then
    return -1
  end
  return i + (j - 1) * g.cols -- todo: not sure why the -1 is needed
end
