pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #95
-- https://www.youtube.com/watch?v=5cNnf_7e92Q

local r = 60
local real_pi = 3.1416 -- real enough
local total
local circle
local record_pi
local record_diff
local done

function _init()
  camera(-64, -64)
  cls(1)
  rect(-r, -r, r, r, 6)
  circ(0, 0, r, 7)
  total = 0
  circle = 0
  record_pi = 32767
  record_diff = 32767
  done = false
end

function _update60()
end

function _draw()
  if (done) return
  if total > 10000 then -- prevent overflow (which means reaching best approximation within the constraints)
    total *= 0.5
    circle *= 0.5
  end
  local best_color
  local pi
  for i = 1, 15 do -- do multiple at a time
    if not done then
      total += 1
      local x = flr(rnd(r * 2)) - r
      local y = flr(rnd(r * 2)) - r
      local d = x * x + y * y
      local color
      if d < r * r then
        circle += 1
        color = 11
      else
        color = rnd_color()
      end
      pset(x, y, color)
      pi = (4 * circle / total)
      local diff = abs(real_pi - pi)
      if diff < record_diff then
        record_diff = diff
        record_pi = pi
      end
      if record_pi == real_pi then
        best_color = 10
        done = true
      else
        best_color = 7
      end
    end
  end
  rectfill(0 - 64, 0 - 64, 51 - 64, 15 - 64, 0)
  print('best: ' .. record_pi, 2 - 64, 2 - 64, best_color)
  print('curr: ' .. pi, 2 - 64, 9 - 64, 7)
end

-- not dark blue (background), white (shapes), or light green (within circle)
function rnd_color()
  local color
  repeat
    color = flr(rnd(16))
  until color != 1 and color != 6 and color != 7 and color != 11
  return color
end
