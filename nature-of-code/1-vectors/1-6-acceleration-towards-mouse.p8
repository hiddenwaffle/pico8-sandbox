pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  poke(0x5f2d, 1)
  mouse_x = 0
  mouse_y = 0
  m = make_mover()
end

function _update60()
  mouse_x = stat(32)
  mouse_y = stat(33)
  m:update()
  -- m:edges()
end

function _draw()
  cls(1)
  m:display()
  circ(mouse_x, mouse_y, 4, 12)
end

-->8

function make_mover()
  return {
    location = make_pvector(64, 64),
    velocity = make_pvector(0, 0),
    acceleration = make_pvector(0, 0),
    update = function (self)
      local mouse = make_pvector(mouse_x, mouse_y)
      mouse:sub(self.location)
      mouse:set_mag(0.5)
      self.acceleration = mouse -- self.acceleration = make_random_2d_pvector()
      self.acceleration:mult(0.25)
      self.velocity:add(self.acceleration)
      self.location:add(self.velocity)
      self.velocity:limit(0.2) -- todo: does this actually do anything?
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
