pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #23
-- https://www.youtube.com/watch?v=ksRoh-10lak

g = { }

function _init()
  camera(-64, -64)
  g.n1 = 1
  g.n2 = 2
  g.n3 = 3
  g.m = 5
  g.a = 1
  g.b = 1
end

function _update60()
  if (btnp(0)) g.m -= 1
  if (btnp(1)) g.m += 1
end

function _draw()
  cls(1)
  local px
  local py
  local first_x
  local first_y
  local radius = 30
  local total = 100
  local increment = 6.283 / total
  for angle = 0.001, 6.283, increment do -- use 2pi and convert later
    local r = supershape(angle)
    local x = radius * r * cos(rad_to_unit(angle))
    local y = radius * r * sin(rad_to_unit(angle))
    if px and py then
      line(x, y, px, py, 7)
    else
      first_x = x
      first_y = y
    end
    px = x
    py = y
  end
  line(px, py, first_x, first_y, 7)
  print('m: ' .. g.m, 4 - 64, 4 - 64, 7)
end

function supershape(theta)
  local part1 = (1 / g.a) * cos(rad_to_unit(theta * g.m / 4))
  part1 = abs(part1)
  part1 = part1 ^ g.n2
  local part2 = (1 / g.b) * sin(rad_to_unit(theta * g.m / 4))
  part2 = abs(part2)
  part2 = part2 ^ g.n3
  local part3 = (part1 + part2) ^ (1/g.n1)
  if (part3 == 0) return 0
  return 1 / part3
end

function rad_to_unit(rad)
  return rad / 6.283
end
