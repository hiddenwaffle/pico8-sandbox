pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #27
-- https://www.youtube.com/watch?v=CKeyIbT3vXI

#include lib/math.p8:0
#include lib/vector-procedural.p8:0

g = { }

function _init()
  g.fireworks = { }
  g.gravity = vector_new(0, 0.01)
end

function _update60()
  if rnd(1) < 0.025 then
    add(g.fireworks, firework_type:new(flr(rnd(127), 127)))
  end
  for firework in all(g.fireworks) do
    firework:update()
    if firework:done() then
      del(g.fireworks, firework)
    end
  end
end

function _draw()
  cls()
  for firework in all(g.fireworks) do
    firework:show()
  end
  -- print(stat(0), 4, 4, 7)
end

-->8

function random_bright_color()
  local color = 7
  local i = flr(rnd(8))
  if (i == 0) color = 7
  if (i == 1) color = 8
  if (i == 2) color = 9
  if (i == 3) color = 10
  if (i == 4) color = 11
  if (i == 5) color = 12
  if (i == 6) color = 14
  if (i == 7) color = 15
  return color
end

-->8

firework_type = { }

function firework_type:new()
  local color = random_bright_color()
  local o = {
    firework = particle_type:new(flr(rnd(127)), 127, true, color),
    exploded = false,
    particles = { }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function firework_type:update()
  if not self.exploded then
    self.firework:apply_force(g.gravity)
    self.firework:update()
    if self.firework.vel.y >= 0 and not self.exploded then
      self.exploded = true
      self:explode()
    end
  end
  for i = #self.particles, 1, -1 do
    local particle = self.particles[i]
    particle:apply_force(g.gravity)
    particle:update()
    if particle:done() then
      del(self.particles, particle)
    end
  end
end

function firework_type:explode()
  for i = 1, 100 do
    local p = particle_type:new(self.firework.pos.x, self.firework.pos.y, false, self.firework.color)
    add(self.particles, p)
  end
end

function firework_type:show()
  if not self.exploded then
    self.firework:show()
  else
    for particle in all(self.particles) do
      particle:show()
    end
  end
end

function firework_type:done()
  return self.exploded and #self.particles == 0
end

-->8

particle_type = { }

function particle_type:new(x, y, firework, color)
  local o = {
    firework = firework,
    lifespan = flr(rnd(128)) + 256,
    pos = vector_new(x, y),
    acc = vector_new(),
    color = color
  }
  if o.firework then
    o.vel = vector_new(0, -rnd(1.25) - 0.50)
  else
    o.vel = vector_new()
    vector_random2d_to_ref(o.vel)
    vector_mult_to_ref(o.vel, rnd(1), o.vel)
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function particle_type:update()
  if not self.firework then
    vector_mult_to_ref(self.vel, 0.98, self.vel)
    self.lifespan -= 4
  end
  vector_add_to_ref(self.vel, self.acc, self.vel)
  vector_add_to_ref(self.pos, self.vel, self.pos)
  vector_mult_to_ref(self.acc, 0, self.acc)
end

function particle_type:apply_force(force)
  vector_add_to_ref(self.acc, force, self.acc)
end

function particle_type:show()
  pset(self.pos.x, self.pos.y, self.color)
end

function particle_type:done()
  return self.lifespan <= 0
end
