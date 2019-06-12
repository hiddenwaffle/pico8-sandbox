pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
end

function _update60()
end

function _draw()
  cls(1)
  draw_circle(64, 64, 96)
end

function draw_circle(x, y, d)
  circ(x, y, d / 2, 12)
  if d > 2 then
    draw_circle(x + d / 2, y, d / 2)
    draw_circle(x - d / 2, y, d / 2)
    -- draw_circle(x, y + d / 2, d / 2)
  end
end
