pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=YNyULRrydVI

#include lib/vector2.p8
#include lib/quick_sort.p8

local width = 128
local height = 128
local points = { }
local hull = { }
local left_most
local current_vertex -- a vertex along the hull
local index = 0      -- index of the current point being checked to see if it is the next vertex
local next_index = -1
local next_vertex
local done = false

function _init()
  local buffer = 8
  for i = 1, 50 do
    add(points, vector2_type:new(flr(rnd(width - (2 * buffer))) + buffer,
                                 flr(rnd(height - (2 * buffer))) + buffer))
  end
  quick_sort(points, function (a, b)
    return a.x - b.x < 0
  end)
  left_most = points[1]
  current_vertex = left_most
  add(hull, current_vertex)
  next_vertex = points[2] -- just a guess
  index = 3 -- start comparing at this index
end

function _update60()
  if (done) return
  local checking = points[index]
  local a = next_vertex:subtract(current_vertex)
  local b = checking:subtract(current_vertex)
  local cross = vector2_type.cross(a, b)
  if cross < 0 then
    next_vertex = checking
    next_index = index
  end
  index += 1
  if index == #points + 1 then
    if next_vertex == left_most then
      done = true
    else
      add(hull, next_vertex)
      current_vertex = next_vertex
      index = 1
      next_vertex = left_most
    end
  end
end

function _draw()
  cls(1)
  for p in all(points) do
    pset(p.x, p.y, 7)
  end
  circfill(left_most.x, left_most.y, 2, 11)
  circfill(current_vertex.x, current_vertex.y, 2, 12)
  line(current_vertex.x, current_vertex.y, next_vertex.x, next_vertex.y, 11)
  if not done then
    local checking = points[index]
    line(current_vertex.x, current_vertex.y, checking.x, checking.y, 7)
  end
  -- hull
  line(hull[1].x, hull[1].y, hull[1].x, hull[1].y, 12)
  for p in all(hull) do
    line(p.x, p.y)
  end
  line(left_most.x, left_most.y)
end
