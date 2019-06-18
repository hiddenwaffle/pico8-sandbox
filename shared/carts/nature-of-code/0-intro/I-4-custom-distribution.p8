pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  vals = { }
  for i = 0, 128 do
    vals[i] = 0
  end
end

function _update60()
  for i = 1, 10 do -- multiple times per frame to speed things up
    -- pick a random number between 0 and 1 based on custom [...]
    local n = montecarlo()
    -- what spot in the array did we pick
    vals[flr(n * 128)] += 1
  end
end

function _draw()
  cls(1)
  for x = 1, #vals do
    line(x, 128, x, 128 - vals[x])
  end
end

-->8

function montecarlo()
  for hack = 1, 10000 do
    local r1 = rnd(1)
    local r2 = rnd(1)
    local y = r1 ^ 2 -- will tend to the shape of half a parabola
    -- local y = r1 -- will tend to the shape of a diagonal line
    if r2 < y then
      return r1
    end
  end
  return 0 -- just in case
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000