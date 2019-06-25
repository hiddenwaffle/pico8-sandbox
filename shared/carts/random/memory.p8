pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
end

function _update60()
  -- poke(flr(rnd(32767)), flr(rnd(32767)))
  -- poke(0x6000 + flr(rnd(8192)), flr(rnd(32767)))
end

function _draw()
  cls(1)
  -- 0x6000 to 0x7fff
  -- little endian
  local offset = 0x6000
  poke(0x6000, 0xF0)     -- [black  (0) | white (f)] pixels
  poke(offset + 1, 0xE9) -- [orange (9) | pink  (e)] pixels
  poke(offset + 200, 0x8c) -- [blue   (c) | red   (8)] pixels
  -- middle line
  for i = 0, 63 do
     -- [blue (c) | white (7)]
    poke(offset + (8192 / 2) + i, 0x7c) -- left most pixels on middle line
  end
  pset(64, 63, 11)
  pset2(64, 64, 11)
  pset2(65, 64, 11)
  pset(64, 65, 11)
  poke(offset + 8191, 0x8c) -- bottom right
end

-- setting right nibble (left pixel)
--     11110000 <-- bitmask
-- and 10101010 current
--     10100000
--  or 00000101 <--- value to set
--     10100101 <--- final
--
-- setting left nibble (right pixel)
--     00001111 <-- bitmask
-- and 10101010 current
--     00001010
--  or 01010000 <--- value to set
--     01011010 <--- final
function pset2(x, y, col)
  local start = 0x6000
  local offset_x2 = x + y * 128
  local even = offset_x2 % 2 == 0 -- todo: can probably use x here instead
  local offset = flr(offset_x2 / 2)
  local target = start + offset
  local current = peek(target)
  local value
  if even then -- set right nibble (left pixel)
    local bitmask = 0xf0 -- 11110000
    local isolated = band(current, bitmask)
    value = bor(isolated, col)
  else -- set left nibble (right pixel)
    local bitmask = 0x0f -- 00001111
    local isolated = band(current, bitmask)
    value = bor(isolated, shl(col, 4)) -- notice shift left
  end
  poke(target, value)
end
