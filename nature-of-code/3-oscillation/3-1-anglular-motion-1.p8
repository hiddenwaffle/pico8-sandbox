pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this is very different from the video because
-- p8 does not have a lot of the functions used

function _init()
  t = 0
  camera(-64, -64)
  local top_left      = make_pvector(-15, -12)
  local top_right     = make_pvector( 15, -12)
  local bottom_right  = make_pvector( 15,  12)
  local bottom_left   = make_pvector(-15,  12)
  poly = make_poly(top_left, top_right, bottom_right, bottom_left)
end

function _update60()
  t += 0.01
  if (t >= 1) t = 0
  poly.rotation = t
end

function _draw()
  cls(1)
  poly:draw()
end

-->8

function make_poly(v1, v2, v3, v4)
  return {
    vs = { v1, v2, v3, v4 },
    rotation = 0,
    draw = function (self) -- draw with rotation
      for i = 1, #self.vs do
        local current = self.vs[i]
        local next
        if i == 4 then
          next = self.vs[1]
        else
          next = self.vs[i + 1]
        end
        local x1 = current.x * cos(self.rotation) - current.y * sin(self.rotation)
        local y1 = current.x * sin(self.rotation) + current.y * cos(self.rotation)
        local x2 = next.x * cos(self.rotation) - next.y * sin(self.rotation)
        local y2 = next.x * sin(self.rotation) + next.y * cos(self.rotation)
        line(x1, y1, x2, y2, 12)
      end
    end
  }
end

-->8

function pvector_div(v, n)
  return make_pvector(v.x / n, v.y / n)
end

function pvector_sub(a, b)
  return make_pvector(a.x - b.x, a.y - b.y)
end

function make_pvector(x, y)
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
      if (self:mag() > 5) then
        self:normalize()
        self:mult(5)
      end
    end,
    get = function (self)
      return make_pvector(self.x, self.y)
    end
  }
end
