pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #35
-- https://www.youtube.com/watch?v=BAejnwN4Ccw

#include lib/vector2d.p8:0

g = { }

function _init()
  g.cities = { }
  local total_cities = 8 -- 8! = 40320
  for i = 1, total_cities do
    add(g.cities, vector2d_type:new(flr(rnd(128)), flr(rnd(128))))
  end
  local d = calc_distance(g.cities)
  g.record_distance = d
  g.best_ever = shallow_index_copy(g.cities)
  g.iteration = 0
end

function _update60()
  local i = flr(rnd(#g.cities)) + 1
  local j = flr(rnd(#g.cities)) + 1
  swap(g.cities, i, j)
  local d = calc_distance(g.cities)
  if d < g.record_distance then
    g.record_distance = d
    g.best_ever = shallow_index_copy(g.cities)
  end
  g.iteration += 1
end

function _draw()
  cls(1)
  -- lines (best ever)
  for i = 1, #g.best_ever do
    local c1 = g.best_ever[i]
    local c2 = g.best_ever[i + 1] or g.best_ever[1] -- next or first (to connect last to first)
    -- pseudo thickness
    line(c1.x - 1, c1.y - 1, c2.x - 1, c2.y - 1, 14)
    line(c1.x, c1.y, c2.x, c2.y, 14)
    line(c1.x + 1, c1.y + 1, c2.x + 1, c2.y + 1, 14)
    line(c1.x - 1, c1.y - 1, c2.x + 1, c2.y + 1, 14)
    line(c1.x - 1, c1.y - 1, c2.x + 1, c2.y + 1, 14)
  end
  -- lines (current)
  for i = 1, #g.cities do
    local c1 = g.cities[i]
    local c2 = g.cities[i + 1] or g.cities[1] -- next or first (to connect last to first)
    line(c1.x, c1.y, c2.x, c2.y, 7)
  end
  -- cities
  for city in all(g.cities) do
    circfill(city.x, city.y, 3, 7)
    circ(city.x, city.y, 3, 0)
  end
  print('record:    ' .. g.record_distance, 4, 4, 11)
  print('iteration: ' .. g.iteration, 4, 11, 12)
end

-->8

function swap(a, i, j)
  local temp = a[j]
  a[j] = a[i]
  a[i] = temp
end

function calc_distance(points)
  local sum = 0
  for i = 1, #points - 1 do -- do not need to connect last to first
    local p1 = points[i]
    local p2 = points[i + 1]
    local d = vector2d_type.dist_16bit(p1, p2)
    sum += d
  end
  return sum
end

function shallow_index_copy(src)
  local dest = { }
  for k, v in pairs(src) do
    dest[k] = v
  end
  return dest
end
