pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this uses generators instead of async await
-- https://www.youtube.com/watch?v=67k3I2GxTH8

g = { }
width = 128
height = 128

function _init()
  g.i = 1
  g.j = 1
  g.values = { }
  for i = 1, width do
    g.values[i] = flr(rnd(height))
  end
  quick_sort(g.values, 1, #g.values)
end

function _update60()
  -- if (g.i >= #g.values) return -- done
  -- for j = 1, #g.values - 1 do
  --   local a = g.values[j]
  --   local b = g.values[j + 1]
  --   if a > b then
  --     swap(g.values, j, j + 1)
  --   end
  -- end
  -- g.i += 1
end

function _draw()
  cls(1)
  for i = 1, #g.values do
    line(i - 1, height, i -1, height - g.values[i], 7)
  end
end

-->8

function quick_sort(arr, start, finish)
  if (start >= finish) return
  local index = partition(arr, start, finish)
  quick_sort(arr, start, index - 1)
  quick_sort(arr, index + 1, finish)
end

function partition(arr, start, finish)
  local pivot_index = start
  local pivot_value = arr[finish]
  for i = start, finish do
    if arr[i] < pivot_value then
      swap(arr, i, pivot_index)
      pivot_index += 1
    end
  end
  swap(arr, pivot_index, finish)
  return pivot_index
end

function swap(arr, a, b)
  local tmp = arr[a]
  arr[a] = arr[b]
  arr[b] = tmp
end
