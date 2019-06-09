pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  len = 64
  origin = make_pvector(64, 0)
  bob = make_pvector(64, len)
  angle = 1/8
  a_vel = 0
  a_acc = 0
end

function _update60()
  bob.x = origin.x + len * sin(angle)
  bob.y = origin.y + len * cos(angle)
  a_acc = 0.001 * sin(angle)
  angle += a_vel
  a_vel += a_acc
  a_vel *= 0.99 -- damping to let it eventually stop
end

function _draw()
  cls(1)
  line(origin.x, origin.y, bob.x, bob.y)
  circfill(bob.x, bob.y, 6, 11)
  circ(bob.x, bob.y, 6, 7)
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
