pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  particles = { }
end

function _update60()
  local p
  if (flr(rnd(2)) == 0) then
    p = make_square_particle()
  else
    p = make_particle()
  end
  add(particles, p)
  for p in all(particles) do
    p:update()
    if p:is_dead() then
      del(particles, p)
    end
  end
end

function _draw()
  cls(1)
  for p in all(particles) do
    p:display()
  end
  print('particles: ' .. #particles, 4, 4, 7)
end

-->8

function make_square_particle()
  local p = make_particle()
  function p:display()
    rectfill(self.location.x - self.mass,
             self.location.y - self.mass,
             self.location.x + self.mass,
             self.location.y + self.mass,
             self.color)
  end
  return p
end

function make_particle()
  return {
    ttl = 100,
    color = rnd(16),
    mass = rnd(2) + 1,
    location = make_pvector(64, rnd(16)),
    velocity = make_pvector(0, 0),
    acceleration = make_pvector((rnd(1) * 0.5) - 0.25, (rnd(1) * 0.6) + 0.6),
    -- newton's 2nd law! (the beginning)
    apply_force = function (self, force)
      local f = pvector_div(force, self.mass)
      self.acceleration:add(f)
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.location:add(self.velocity)
      self.acceleration:mult(0)
      self.ttl -= 1
    end,
    display = function (self)
      circfill(self.location.x, self.location.y, self.mass, self.color)
      -- circ(self.location.x, self.location.y, self.mass, 0)
    end,
    is_dead = function (self)
      return self.ttl <= 0
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
