pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  m = make_mover()
end

function _update60()
  m:update()
  m:edges()
end

function _draw()
  cls(1)
  m:display()
end

-->8

function make_mover()
  return {
    location = make_pvector(64, 64),
    velocity = make_pvector(0, 0),
    acceleration = make_pvector(0, 0),
    update = function (self)
      self.acceleration = make_random_2d_pvector()
      self.acceleration:mult(0.25)
      self.velocity:add(self.acceleration)
      self.location:add(self.velocity)
      self.velocity:limit(5)
    end,
    edges = function (self)
      if (self.location.x > 127)  self.location.x = 0
      if (self.location.x < 0)    self.location.x = 127
      if (self.location.y > 127)  self.location.y = 0
      if (self.location.y < 0)    self.location.y = 127
    end,
    display = function (self)
      circfill(self.location.x, self.location.y, 6, 11)
    end
  }
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
      return sqrt(self.x ^ 2 + self.y ^ 2)
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
    end
  }
end

function make_random_2d_pvector()
  local v = make_pvector(rnd(2) - 1, rnd(2) - 1)
  v:normalize()
  return v
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
