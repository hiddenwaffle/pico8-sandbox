pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- from the quick sort visualization:
-- https://www.youtube.com/watch?v=67k3I2GxTH8

function quick_sort(arr, compare, start, finish)
  compare = compare or quick_sort_default_compare
  start = start or 1
  finish = finish or #arr
  if (start >= finish) return
  local index = quick_sort_partition(arr, compare, start, finish)
  quick_sort(arr, compare, start, index - 1)
  quick_sort(arr, compare, index + 1, finish)
end

function quick_sort_partition(arr, compare, start, finish)
  local pivot_value = arr[finish]
  local pivot_index = start
  for i = start, finish do
    if compare(arr[i], pivot_value) then
      quick_sort_swap(arr, i, pivot_index)
      pivot_index += 1
    end
  end
  quick_sort_swap(arr, pivot_index, finish)
  for i = start, finish do
  end
  return pivot_index
end

function quick_sort_swap(arr, a, b)
  local tmp = arr[a]
  arr[a] = arr[b]
  arr[b] = tmp
end

function quick_sort_default_compare(a, b)
  return a < b
end
