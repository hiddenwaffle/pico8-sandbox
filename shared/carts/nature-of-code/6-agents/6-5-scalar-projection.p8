pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  poke(0x5f2d, 1)
  g_a = make_vector(5, 106)
  g_b = make_vector(106, 88)
end

function _update60() -- todo: runs after _init() and before _draw() ?
  capture_mouse()
  norm = vector_projection(mouse, g_a, g_b)
end

function _draw()
  cls(1)
  line(g_a.x, g_a.y, mouse.x, mouse.y, 9)
  line(g_a.x, g_a.y, g_b.x, g_b.y, 12)
  line(mouse.x, mouse.y, norm.x, norm.y, 7)
  circ(mouse.x, mouse.y, 4, 6)
  circ(norm.x, norm.y, 4, 15)
  print(norm.x .. ', ' .. norm.y, 4, 4, 7)
end

-->8

function capture_mouse()
  mouse = make_vector(stat(32), stat(33))
end

-->8

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

-->8

function vector_div(v, n)
  return make_vector(v.x / n, v.y / n)
end

function vector_add(a, b)
  return make_vector(a.x + b.x, a.y + b.y)
end

function vector_sub(a, b)
  return make_vector(a.x - b.x, a.y - b.y)
end

function vector_angle_between(a, b)
  return acos(a:dot(b) / (a:mag() * b:mag()))
end

function vector_projection(p, a, b)
  local ap = vector_sub(p, a)
  local ab = vector_sub(b, a)
  ab:normalize()
  ab:mult(ap:dot(ab))
  return vector_add(a, ab)
end

function make_vector(x, y)
  return {
    x = x,
    y = y,
    add = function (self, other)
      self.x += other.x
      self.y += other.y
    end,
    sub = function (self, other)
      self.x -= other.x
      self.y -= other.y
    end,
    mult = function (self, amt)
      self.x *= amt
      self.y *= amt
    end,
    mag = function (self)
      return sqrt(self:mag_sq())
    end,
    mag_sq = function (self)
      return self.x ^ 2 + self.y ^ 2
    end,
    normalize = function (self)
      local m = self:mag()
      if (m == 0) m = 0.01 -- bandaid
      self.x /= m
      self.y /= m
    end,
    set_mag = function (self, amt)
      self:normalize()
      self:mult(amt)
    end,
    limit = function (self, amt)
      if (self:mag() > amt) then
        self:normalize()
        self:mult(amt)
      end
    end,
    get = function (self)
      return make_vector(self.x, self.y)
    end,
    dot = function (self, v)
      return self.x * v.x + self.y * v.y
    end
  }
end
