pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

#include lib/vector2.p8

function _init()
  reset()
end

function reset()
  cls(1)
  g.t = 0
  g.points = { }
  local n = 5
  local offset = vector2_type:new(64, 64)
  local color = 0
  for angle = 0, 1, 1 / n do
    local v = vector2_type.from_angle(angle)
    v:scale_in_place(60)
    v:add_in_place(offset)
    add(g.points, v)
    v.color = (7 + color) % 16
    color += 1
  end
  g.current = vector2_type:new(flr(rnd(128)), flr(rnd(128)))
  g.percent = 0.5
  g.previous = nil
end

function _update60()
  g.t += 1
  if g.t > 60 * 3 then
    -- reset()
  end
end

function _draw()
  for i = 1, 25 do
    for p in all(g.points) do
      local next = g.points[flr(rnd(#g.points)) + 1]
      if previous and not next:equals(previous) then
        g.current.x = lerp(g.current.x, next.x, g.percent)
        g.current.y = lerp(g.current.y, next.y, g.percent)
        pset(g.current.x, g.current.y, next.color)
      end
      previous = next
    end
  end
end

function lerp(a, b, amt)
  return a + (b - a) * amt
end
