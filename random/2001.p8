pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- Posted by zep.p8 on Twitter
-- Resembles effects from 2001: A Space Odyssey
-- https://twitter.com/lexaloffle/status/1136321750898171906
poke(0x5f2c, 5)
t = 0
::STAR::
t += 1
for x = 0, 63 do
  local z, u, q
  z = 5 / sin((x + 9) / 812)
  u = flr((z - t * 1.5) / 5)
  q = 3 + cos(u / 99) * 2.9
  for y = -64 + t % 2, 64, 2 do
    local c, v = 0, flr(y * (z / 8) / 10)
    if (u * u + v * (v + 3711)) % 9.4 < q then
      c = ((u ^ 2 * (v + 101) ^ 2)) %3
      c = 7 + ((c + (u / 8)) % 9)
    end
    pset(63 - x, 64 + y, c)
  end
end
flip()
goto STAR

-- function _update60()
-- end

-- function _draw()
-- end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000