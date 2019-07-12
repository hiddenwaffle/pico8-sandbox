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
  g.states = { }
  for i = 1, width do
    g.values[i] = flr(rnd(height))
    g.states[i] = -1
  end
  g.c = cocreate(quick_sort)
end

function _update60()
  coresume(g.c, g.values, 1, #g.values)
end

function _draw()
  cls(1)
  for i = 1, #g.values do
    color = 7
    if g.states[i] == 0 then
      color = 8
    elseif g.states[i] == 1 then
      color = 12
    end
    line(i - 1, height, i -1, height - g.values[i], color)
  end
end

-->8

function quick_sort(arr, start, finish)
  if (start >= finish) return
  local index = partition(arr, start, finish)
  g.states[index] = -1
  quick_sort(arr, start, index - 1)
  quick_sort(arr, index + 1, finish)
end

function partition(arr, start, finish)
  for i = start, finish do
    g.states[i] = 1
  end
  local pivot_value = arr[finish]
  local pivot_index = start
  g.states[pivot_index] = 0
  for i = start, finish do
    if arr[i] < pivot_value then
      swap(arr, i, pivot_index)
      g.states[pivot_index] = -1
      pivot_index += 1
      g.states[pivot_index] = 0
    end
  end
  swap(arr, pivot_index, finish)
  for i = start, finish do
    if (i != pivot_index) g.states[i] = -1
  end
  return pivot_index
end

function swap(arr, a, b)
  local tmp = arr[a]
  arr[a] = arr[b]
  arr[b] = tmp
  yield()
end
