pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- friction force = -1 * mu * ||normal force|| * unit velocity,
-- mu = coefficient of friction
-- where ||normal force|| = 1 in this universe (to not need trigonometry for now)

-- drag force = -1/2 * rho * ||v||^2 * a * c * ||v||
-- where rho is density (todo: of the object or the fluid?)
-- ||v|| is speed
-- "the faster something is moving [..] the more drag it will experience."
-- "a force that is tied to a property (density, speed) of an object"
-- a = surface area
-- c = coefficient of drag "what are the two things coming in contact with each other"
--
-- in this universe, density = 1, surface area = 1
-- therefore simplified formula here is:
-- friction force = -c * ||v||^2 * unit velocity

-- notice that the smaller spheres fall through the water slower

function _init()
  movers = { }
  for i = 1, 3 do
    movers[i] = make_mover(i % 3 + 9)
  end
  water_line = 72
end

function _update60()
  for m in all(movers) do
    local gravity = make_pvector(0, 0.2)
    gravity:mult(m.mass) -- cancels out mass for more "accurate" gravity
    m:apply_force(gravity)
    local wind = make_pvector(0.1, 0)
    m:apply_force(wind)
    -- apply drag if below water line
    if m.location.y >= water_line then
      local drag = m.velocity:get()
      drag:normalize()
      local c = -0.0005
      local speed_sq = m.velocity:mag_sq() -- "speed squared"
      drag:mult(c * speed_sq)
      m:apply_force(drag)
    end
  end
  for m in all(movers) do
    m:update()
    m:edges()
  end
  if btnp(5) then
    for i = 1, #movers do
      -- copied from _init()... todo: unduplicate
      movers[i] = make_mover(i % 3 + 9)
    end
  end
end

function _draw()
  cls(1)
  rectfill(0, water_line, 127, 127, 12)
  print('press x to reset', 4, 4, 13)
  for m in all(movers) do
    m:display()
  end
end

-->8

function make_mover(color)
  return {
    color = color,
    mass = rnd(2) + 1,
    location = make_pvector(rnd(128), rnd(16)),
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
    edges = function (self)
      if (self.location.x > 127) then
        self.location.x = 127
        self.velocity.x *= -1
      end
      if (self.location.x < 0) then
        self.location.x = 0
        self.velocity.x *= -1
      end
      if (self.location.y > 127) then
        self.location.y = 127
        self.velocity.y *= -1
      end
      if (self.location.y < 0) then
        self.location.y = 0
        self.velocity.y *= -1
      end
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
