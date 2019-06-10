pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  m = make_mover()
end

function _update60()
  local gravity = make_pvector(0, 0.2)
  m:apply_force(gravity)
  if (btn(5)) then
    local wind = make_pvector(0.1, 0)
    m:apply_force(wind)
  end
  m:update()
  m:edges()
end

function _draw()
  cls(1)
  print('press x to simulate wind', 15, 32, 12)
  m:display()
end

-->8

function make_mover()
  return {
    location = make_pvector(64, 64),
    velocity = make_pvector(0, 0),
    acceleration = make_pvector(0, 0),
    -- newton's 2nd law! (the beginning)
    apply_force = function (self, f)
      self.acceleration:add(f)
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.location:add(self.velocity)
      self.acceleration:mult(0)
    end,
    edges = function (self)
      if (self.location.x > 127) then
        self.location.x = 127
        self.velocity.x *= -1
        sfx(0)
      end
      if (self.location.x < 0) then
        self.location.x = 0
        self.velocity.x *= -1
        sfx(0)
      end
      if (self.location.y > 127) then
        self.location.y = 127
        self.velocity.y *= -1
        sfx(0)
      end
      if (self.location.y < 0) then
        self.location.y = 0
        self.velocity.y *= -1
        sfx(0)
      end
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
      if (self:mag() > amt) then
        self:normalize()
        self:mult(amt)
      end
    end
  }
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001f0501f0501f0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
