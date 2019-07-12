pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this demonstrates how to use generators to "pause" within a calculation
-- to be able to draw the intermediate results.

function _init()
  cls()
  local arr = { 1, 10, 100, 1000 }
  local c = cocreate(inc)
  for i = 1, 10 do
    coresume(c, arr) -- could i pass a different arr here? or does it keep first values?
    print_table(arr)
  end
end

function inc(arr)
  while true do
    for i = 1, #arr do
      arr[i] += 1
    end
    yield()
  end
end

function print_table(t)
  local str = ''
  for k, v in pairs(t) do
    str = str .. k .. '->' .. v .. ' '
  end
  print(str)
end
