pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_table_defined_ = true

function table_contains(a, target)
  local found = false
  function check(e)
    if target == e then
      found = true
    end
  end
  foreach(a, check)
  return found
end

function table_splice(a, start, count)
  count = count or (#a - start + 1)
  local subset = { }
  for i = start, start + count - 1 do
    add(subset, a[i])
  end
  for x in all(subset) do
    del(a, x)
  end
  return subset
end

-- todo: make more efficient
function table_reverse(a)
  local reversed = { }
  for i = #a, 1, -1 do
    add(reversed, a[i])
  end
  for i = 1, #reversed do
    a[i] = reversed[i]
  end
end

-- in place
function table_concat(dest, src)
  for x in all(src) do
    add(dest, x)
  end
end

-- from https://www.lexaloffle.com/bbs/?pid=43636
-- converts anything to string, even nested tables
function table_tostring(any)
  assert(type(any) == 'table')
  local str = '{ '
  for k, v in pairs(any) do
    str = str .. tostring(k) .. ' -> ' .. tostring(v) .. ' '
  end
  return str .. '}'
end

function table_shallow_index_copy(src)
  local dest = { }
  for k, v in pairs(src) do
    dest[k] = v
  end
  return dest
end
