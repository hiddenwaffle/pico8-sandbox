pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- from:
-- https://twitter.com/lucatron_/status/1144337102399651840
-- refactored for explanation

e = { 3, 11, 5, 8, 14, 2, 9, 10, 4, 13, 7, 6 }
::_::
-- this acts as like an imprecise screen clear
-- it gives moving objects a trail-like particle effect
color(1)
for i = 0, 80 do -- fewer or more lines affect the strength of the trail
  line(rnd(128),rnd(128))
end
for n = 1, 10, 3 do -- 1 = green, 4 = red, 7 = yellow, 10 = white
  a = n / 4 - t() / 4 -- first 4 is spacing of gems, second 4 is speed of rotation around world origin
  -- 64, 64 as the origin of rotation, 42 pixels away
  x = 64 + cos(a) * 42
  y = 64 + sin(a) * 42
  -- draw the gems
  for j = -1, 1, .02 do -- step by .02 to have 11 line pairs drawn
    i = flr(j + t() * 3) -- used to determine the color of the line drawn, 3 is the speed of rotation around object y-axis
    -- draw lower part of the gem
    -- x, y is the bottom point
    line(x, y + 20, x + j * 20, y, e[n + i % 3])
    color(e[n + (i + 1) % 3]) -- alternate the color for the next line()
    -- draw upper part of the gem
    line(x + j * 10, y - 10) -- 2 args: reuses the previous end point of line()
  end
end
flip()
goto _
