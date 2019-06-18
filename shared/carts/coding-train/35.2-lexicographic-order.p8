pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #35.2
-- https://www.youtube.com/watch?v=goUlyp4rwiU

#include lib/table.p8:0

g = { }

function _init()
  g.vals = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
  g.done = false
end

function calculate()
  -- step 1
  local largest_i = -1
  for i = 1, #g.vals - 1 do
    if g.vals[i] < g.vals[i + 1] then
      largest_i = i
    end
  end
  if largest_i == -1 then
    return true -- done
  end
  -- step 2
  local largest_j = -1
  for j = 1, #g.vals do
    if g.vals[largest_i] < g.vals[j] then
      largest_j = j
    end
  end
  -- step 3
  swap(g.vals, largest_i, largest_j)
  -- step 4
  local len = #g.vals - largest_i - 1
  local end_array = table_splice(g.vals, largest_i + 1)
  table_reverse(end_array)
  table_concat(g.vals, end_array)
  return false
end

function _update60()
  if not g.done then
    g.done = calculate()
  end
end

function _draw()
  cls(1)
  local s = ''
  for i = 1, #g.vals do
    s = s .. g.vals[i]
  end
  print(s, 43, 48, 7)
end

function swap(a, i, j)
  local temp = a[j]
  a[j] = a[i]
  a[i] = temp
end
