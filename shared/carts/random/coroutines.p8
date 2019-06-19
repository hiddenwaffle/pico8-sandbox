pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }
local c
local d

function _init()
  c = cocreate(hey)
  d = cocreate(there)
  cls()
  g.state = 1
  print('start state: ' .. costatus(c))
  while costatus(c) != 'dead' and costatus(d) != 'dead' do
    print('1 state: ' .. g.state)
    coresume(c)
    print('state after coresume(): ' .. costatus(c))
    print(' 2 state: ' .. g.state)
    coresume(d)
  end
  print('final state: ' .. g.state)
end

-- function _update60()
-- end

-- function _draw()
-- end

function hey()
  print('doing something')
  print('state in hey(): ' .. costatus(c))
  g.state += 1
  yield()
  print('doing the next thing')
  g.state += 1
  yield()
  print('finished')
  g.state += 1
end

function there()
  print('x')
  g.state *= 2
  yield()
  print('y')
  g.state *= 2
  yield()
  print('z')
  g.state *= 2
end
