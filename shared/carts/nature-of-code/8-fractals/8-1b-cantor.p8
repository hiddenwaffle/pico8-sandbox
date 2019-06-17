pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- cannot go too far due to resolution

function _init()
end

function _update60()
end

function _draw()
  cls(1)
  cantor(0, 4, 128)
end

function cantor(x, y, len)
  local h = 22
  if len >= 1 then
    rectfill(x, y, x + len, y + h / 3)
    y += h
    cantor(x, y, len / 3)
    cantor(x + len * 2 / 3, y, len / 3)
  end
end
