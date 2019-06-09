pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- this is very different from the video because
-- p8 does not have a lot of the functions used

function _init()
  len = 64
  origin = make_pvector(64, 0)
  bob = make_pvector(64, len)
end

function _update60()
end

function _draw()
  cls(1)
  line(origin.x, origin.y, bob.x, bob.y)
  circ(bob.x, bob.y, 6)
end

-->8

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
      return sqrt(self.mag_sq)
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
