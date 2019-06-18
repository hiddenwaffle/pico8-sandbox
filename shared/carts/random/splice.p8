pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  cls()
  local a = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' }
  local b = splice(a, 3, 3)
  print('--- a')
  foreach(a, print)
  print('--- b')
  foreach(b, print)
  local c = { 'a', 'b', 'c', 'd', 'e' }
  print('--- d')
  local d = splice(c, 3, 1)
  foreach(d, print)
  local e = { 'a', 'b', 'c', 'd', 'e' }
  local f = splice(e, 3)
  print('--- f')
  foreach(f, print)
end

-- todo: maybe put into a library
function splice(a, start, count)
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
