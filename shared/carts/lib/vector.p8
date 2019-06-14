pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

assert(lib_math_defined__)
lib_vector_defined_ = true

function vector_new(x, y)
  return {
    x = x or 0,
    y = y or 0
  }
end

function vector_random2d_to_ref(ref) -- note: not normalized
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

function vector_magnitude(v)
  return sqrt(vector_magnitude_sq(v))
end

function vector_magnitude_sq(v)
  return v.x ^ 2 + v.y ^ 2
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

-->8
-- todo: unit tests
