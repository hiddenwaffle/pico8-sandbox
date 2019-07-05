pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = {
  count = 0
}

function _init()
  cls()
  local c = cocreate(do_it)
  for i = 1, 10 do
    print('count: ' .. g.count)
    coresume(c)
  end
end

function do_it()
  for i = 1, 5 do
    print('incrementing count')
    g.count += 1
    yield()
  end
end

-- function _update60()
-- end

-- function _draw()
-- end
