pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this doesn't work, probably because the 0-based
-- indexes are not translating well to lua's 1-based indexes.

-- coding challenge #33
-- https://www.youtube.com/watch?v=flQgnCUxHlw

#include lib/vector.p8:0

g = { }

function _init()
  g.r = 4
  g.k = 30
  g.grid = { }
  g.w = g.r / sqrt(2) -- n = 2
  g.active = { }
  -- step 0
  g.cols = flr(128 / g.w)
  g.rows = flr(128 / g.w)
  for i = 0, g.cols * g.rows - 1 do
    g.grid[i] = nil
  end
  -- step 1
  local x = flr(rnd(128))
  local y = flr(rnd(128))
  local i = flr(x / g.w)
  local j = flr(y / g.w)
  local pos = vector_type:new(x, y)
  g.grid[i + j * g.cols] = pos
  g.active[0] = pos
end

function _update60()
  if active_count() > 0 then -- while #g.active > 0 do
    local rand_index = flr(rnd(active_count()))
    local pos = g.active[rand_index]
    assert(pos)
    local found = false
    for n = 0, g.k - 1 do
      local sample = vector_type.random_vector()
      local m = rnd(g.r) + g.r
      sample:set_mag(m)
      sample:add(pos)
      local col = flr(sample.x / g.w)
      local row = flr(sample.y / g.w)
      if col > -1 and row > -1 and col < g.cols and row < g.rows and g.grid[col + row * g.cols] == nil then
        local ok = true
        for i = -1, 1 do
          for j = -1, 1 do
            local index = (col + i) + (row + j) * g.cols
            local neighbor = g.grid[index]
            if neighbor then
              local d = vector_type.dist_16bit(sample, neighbor)
              if d < g.r then
                ok = false
              end
            end
          end
        end
        if ok then
          found = true
          g.grid[col + row * g.cols] = sample
          g.active[active_count()] = sample
          break
        end
      end
    end
    if not found then
      del(g.active, g.active[rand_index])
    end
  end
end

function _draw()
  cls(1)
  for i = 0, grid_count() - 1 do
    local cell = g.grid[i]
    if cell then
      pset(cell.x, cell.y, 11)
    end
  end
  for i = 0, active_count() - 1 do
    local cell = g.active[i]
    pset(cell.x, cell.y, 2)
  end
  print('active ' .. active_count(), 4, 4, 7)
end

function active_count()
  local extra = 0
  if g.active[0] then
    extra = 1
  end
  return #g.active + extra
end

function grid_count()
  local extra = 0
  if g.grid[0] then
    extra = 1
  end
  return #g.grid + extra
end
