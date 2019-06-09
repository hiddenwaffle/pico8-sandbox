pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- f = -k * x (hooke's law)
-- k is a constant
-- x is the displacement from its rest positition

function _init()
  origin = make_pvector(64, 0)
  rest_length = 64
  bob = make_mover(64, rest_length + 12, 7)
end

function _update60()
  local spring = pvector_sub(bob.location, origin)
  local current_length = spring:mag()
  spring:normalize()
  local k = 0.05
  local stretch = current_length - rest_length
  spring:mult(-k * stretch)
  bob:apply_force(spring)
  bob:update()
end

function _draw()
  cls(1)
  print(bob.acceleration.y, 4, 4, 7)
  line(origin.x, origin.y, bob.location.x, bob.location.y, 7)
  bob:display()
end

-->8

function make_mover(x, y, color)
  return {
    color = color,
    mass = rnd(2) + 1,
    location = make_pvector(x, y),
    velocity = make_pvector(0, 0),
    acceleration = make_pvector(0, 0),
    -- newton's 2nd law! (the beginning)
    apply_force = function (self, force)
      local f = pvector_div(force, self.mass)
      self.acceleration:add(f)
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.location:add(self.velocity)
      self.acceleration:mult(0)
    end,
    display = function (self)
      circfill(self.location.x, self.location.y, self.mass * 5, self.color)
      circ(self.location.x, self.location.y, self.mass * 5, 0)
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
