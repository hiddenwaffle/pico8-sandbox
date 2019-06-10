pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  poke(0x5f2d, 1)
  mouse_x = 0
  mouse_y = 0
  v = make_vehicle(64, 64)
end

function _update60()
  mouse_x = stat(32)
  mouse_y = stat(33)
  local mouse = make_vector(mouse_x, mouse_y)
  v:seek(mouse)
  v:update()
end

function _draw()
  cls(1)
  v:display()
  circ(mouse_x, mouse_y, 4, 12)
  -- print(v.location.x .. ', ' .. v.location.y, 4, 4, 7)
end

-->8

function make_vehicle(x, y)
  return {
    acceleration = make_vector(0, 0),
    velocity = make_vector(0, -2),
    location = make_vector(x, y),
    r = 6,
    maxspeed = 0.04,
    maxforce = 0.1,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.velocity:limit(self.maxspeed)
      self.location:add(self.velocity)
      self.acceleration:mult(0)
    end,
    apply_force = function (self, force)
      self.acceleration:add(force)
    end,
    seek = function (self, target)
      local desired = vector_sub(target, self.location)
      -- desired:normalize()
      desired:mult(self.maxspeed)
      local steer = vector_sub(desired, self.velocity)
      steer:limit(self.maxforce)
      self:apply_force(steer)
    end,
    display = function (self)
      -- todo: draw a triangle
      rect(self.location.x - 1, self.location.y -1,
           self.location.x + 1, self.location.y + 1,
           7)
    end
  }
end

-->8

function vector_div(v, n)
  return make_vector(v.x / n, v.y / n)
end

function vector_sub(a, b)
  return make_vector(a.x - b.x, a.y - b.y)
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
    end
  }
end
