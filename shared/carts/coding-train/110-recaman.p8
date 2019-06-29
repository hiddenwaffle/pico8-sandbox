pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=DhFZfzOvNTU
-- left off at 14:30

g = { }

function setup()
  cls(1)
  camera(0, -64)
  g.numbers = { }
  g.count = 1
  g.sequence = { }
  g.index = 0
  -- start
  g.numbers[g.index] = true
  add(g.sequence, index)
end

function step()
  local next = g.index - g.count
  if next < 0 or g.numbers[next] then
    next = g.index + g.count
  end
  g.numbers[next] = true
  add(g.sequence, next)

  local radius = (next - g.index) / 2
  local x = (next + g.index) / 2
  circ(x, 0, radius, 7)

  g.index = next
  g.count += 1
end

setup()
::loop::
step()
flip()
goto loop
