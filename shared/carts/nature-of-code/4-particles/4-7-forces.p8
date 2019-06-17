pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  poke(0x5f2d, 1)
  mouse_x = 0
  mouse_y = 0
  pss = { make_particle_system(64, 12) }
end

function _update60()
  mouse_x = stat(32)
  mouse_y = stat(33)
  if btnp(5) then
    local ps = make_particle_system(mouse_x, mouse_y) -- (rnd(8) + (64 - 4), rnd(16) + 16)
    add(pss, ps)
  end
  local gravity = make_pvector(0, 0.05)
  for ps in all(pss) do
    ps:apply_force(gravity)
    ps:add_particle()
    ps:update()
  end
  if btnp(4) then
    for ps in all(pss) do
      local wind = make_pvector(0.5, 0)
      ps:apply_force(wind)
    end
  end
end

function _draw()
  cls(1)
  for ps in all(pss) do
    ps:display()
  end
  print('press ❎ to add - mem: ' .. flr(stat(0)), 4, 4, 7)
  print('press 🅾️ for wind', 4, 11, 7)
  circ(mouse_x, mouse_y, 4, 12)
end

-->8

function make_particle_system(x, y)
  local particles = { }
  return {
    x = x,
    y = y,
    particles = particles,
    add_particle = function (self)
      add(self.particles, make_particle(self.x, self.y))
    end,
    apply_force = function (self, force)
      for p in all(self.particles) do
        p:apply_force(force)
      end
    end,
    update = function (self)
      for p in all(self.particles) do
        p:update()
        if p:is_dead() then
          del(self.particles, p)
        end
      end
    end,
    display = function (self)
      for p in all(self.particles) do
        p:display()
      end
    end
  }
end

-->8

function make_particle(x, y)
  return {
    ttl = 100,
    color = rnd(16),
    mass = rnd(2) + 1,
    location = make_pvector(x + rnd(8) - 4, y + rnd(16) + 4),
    velocity = make_pvector(0, -0.3),
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
      if (self:mag() > amt) then
        self:normalize()
        self:mult(amt)
      end
    end,
    get = function (self)
      return make_pvector(self.x, self.y)
    end
  }
end
