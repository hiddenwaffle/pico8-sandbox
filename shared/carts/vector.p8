pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function vector_new(x, y)
  return {
    x = x,
    y = y
  }
end

function vector_random2d_to_ref(ref)
  ref.x = rnd(2) - 1
  ref.y = rnd(2) - 1
end

function vector_div_to_ref(v, n, ref)
  ref.x = v.x / n
  ref.y = v.y / n
end

function vector_add_to_ref(a, b, ref)
  ref.x = a.x + b.x
  ref.y = a.y + b.y
end

function vector_sub_to_ref(a, b, ref)
  ref.x = a.x - b.x
  ref.y = a.y - b.y
end

function vector_angle_between(a, b, ref)
  return acos(a:dot(b) / (a:mag() * b:mag()))
end

function vector_dist(a, b)
  return sqrt((b.x - a.x) ^  2 + (b.y - a.y) ^ 2)
end

function vector_projection(p, a, b)
  local ap = vector_sub(p, a)
  local ab = vector_sub(b, a)
  ab:normalize()
  ab:mult(ap:dot(ab))
  return vector_add(a, ab)
end

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

-- function make_vector(x, y)
--   return {
--     x = x,
--     y = y,
--     add = function (self, other)
--       self.x += other.x
--       self.y += other.y
--     end,
--     sub = function (self, other)
--       self.x -= other.x
--       self.y -= other.y
--     end,
--     mult = function (self, amt)
--       self.x *= amt
--       self.y *= amt
--     end,
--     div = function (self, amt)
--       self.x /= amt
--       self.y /= amt
--     end,
--     mag = function (self)
--       return sqrt(self:mag_sq())
--     end,
--     mag_sq = function (self)
--       return self.x ^ 2 + self.y ^ 2
--     end,
--     normalize = function (self)
--       local m = self:mag()
--       if (m == 0) m = 0.01 -- bandaid
--       self.x /= m
--       self.y /= m
--     end,
--     set_mag = function (self, amt)
--       self:normalize()
--       self:mult(amt)
--     end,
--     limit = function (self, amt)
--       if (self:mag() > amt) then
--         self:normalize()
--         self:mult(amt)
--       end
--     end,
--     get = function (self)
--       return make_vector(self.x, self.y)
--     end,
--     dot = function (self, v)
--       return self.x * v.x + self.y * v.y
--     end,
--     heading = function (self)
--       return vector_angle_between(self, make_vector(1, 0))
--     end
--   }
-- end
