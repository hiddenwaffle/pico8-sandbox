pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #35.3
-- https://www.youtube.com/watch?v=9Xy-LMAfglE

#include lib/vector2d.p8:0
#include lib/table.p8:0

g = { }

function _init()
  g.cities = { }
  g.order = { } -- from lexicographic order
  local total_cities = 8 -- 8! = 40320 iterations, which would overflow is ran to completion
  for i = 1, total_cities do
    add(g.cities, vector2d_type:new(flr(rnd(128)), 25 + flr(rnd(128 - 25))))
    -- the 25 in the line above is to make room for 3 text lines
    add(g.order, i)
  end
  g.record_distance = 32767
  g.best_ever = table_shallow_index_copy(g.order)
  g.iteration = 0
  g.t = 0
end

function _update60()
  -- g.t += 1
  -- if g.t >= 12 then
    -- g.t = 0
    do_it()
  -- end
end

function do_it()
  next_order()
  local d = calc_distance(g.cities, g.order)
  if d < g.record_distance then
    g.record_distance = d
    g.best_ever = table_shallow_index_copy(g.order)
  end
  g.iteration += 1
end

function _draw()
  cls(1)
  -- lines (best ever)
  for i = 1, #g.best_ever - 1 do
    local n = g.best_ever[i]
    local n2 = g.best_ever[i + 1]
    local c1 = g.cities[n]
    local c2 = g.cities[n2]
    -- pseudo thickness
    line(c1.x - 1, c1.y - 1, c2.x - 1, c2.y - 1, 14)
    line(c1.x, c1.y, c2.x, c2.y, 14)
    line(c1.x + 1, c1.y + 1, c2.x + 1, c2.y + 1, 14)
    line(c1.x - 1, c1.y - 1, c2.x + 1, c2.y + 1, 14)
    line(c1.x - 1, c1.y - 1, c2.x + 1, c2.y + 1, 14)
  end
  -- lines (current)
  for i = 1, #g.order - 1 do -- no need to connect last to first?
    local n = g.order[i]
    local n2 = g.order[i + 1]
    local c1 = g.cities[n]
    local c2 = g.cities[n2]
    line(c1.x, c1.y, c2.x, c2.y, 7)
  end
  -- cities
  for city in all(g.cities) do
    circfill(city.x, city.y, 3, 7)
    circ(city.x, city.y, 3, 0)
  end
  print('record:    ' .. g.record_distance, 4, 4, 11)
  print('iteration: ' .. g.iteration, 4, 11, 12)
  -- from lexicographic order
  local s = ''
  for i = 1, #g.order do
    s = s .. g.order[i]
  end
  print(s, 4, 18, 7)
end

-->8

function swap(a, i, j)
  local temp = a[j]
  a[j] = a[i]
  a[i] = temp
end

function calc_distance(points, order)
  local sum = 0
  for i = 1, #order - 1 do -- do not need to connect last to first
    local city_a_index = order[i]
    local city_a = points[city_a_index]
    local city_b_index = order[i + 1]
    local city_b = points[city_b_index]
    local d = vector2d_type.dist_16bit(city_a, city_b)
    sum += d
  end
  return sum
end

-- from lexicographic order
function next_order()
  -- step 1
  local largest_i = -1
  for i = 1, #g.order - 1 do
    if g.order[i] < g.order[i + 1] then
      largest_i = i
    end
  end
  if largest_i == -1 then
    return true -- done
  end
  -- step 2
  local largest_j = -1
  for j = 1, #g.order do
    if g.order[largest_i] < g.order[j] then
      largest_j = j
    end
  end
  -- step 3
  swap(g.order, largest_i, largest_j)
  -- step 4
  local len = #g.order - largest_i - 1
  local end_array = table_splice(g.order, largest_i + 1)
  table_reverse(end_array)
  table_concat(g.order, end_array)
  return false
end
