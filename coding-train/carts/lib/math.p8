pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_math_defined__ = true

-- From:
-- https://www.lexaloffle.com/bbs/?pid=52433
-- http://developer.download.nvidia.com/cg/acos.html
function acos(x)
  local negate = (x < 0 and 1.0 or 0.0)
  x = abs(x)
  local ret = -0.0187293
  ret *= x
  ret += 0.0742610
  ret *= x
  ret -= 0.2121144
  ret *= x
  ret += 1.5707288
  ret *= sqrt(1.0 - x)
  ret -= 2 * negate * ret
  ret = negate * 3.14159265358979 + ret
  return ret / (2 * 3.14159265358979) -- map to [0, 1)
end

function map_project(val, s_start, s_end, d_start, d_end)
  return ((val - s_start) / (s_end - s_start)) * (d_end - d_start) + d_start
end
-- cls()
-- print('test ' .. map_project(96, 0, 127, -2, 2))
-- assert(false)
-- ((96 - 0)  / (127 - 0) * (2 - -2) + -2
-- (96 / 127) * (2 + 2) - 2
--0.7559055118 * 4 - 2
-- 1.0236220472

-->8
-- todo: unit tests
