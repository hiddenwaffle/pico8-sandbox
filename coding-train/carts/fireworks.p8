pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #27
-- https://www.youtube.com/watch?v=CKeyIbT3vXI

#include lib/math.p8:0
#include lib/vector.p8:0

g = { }

function _init()
  g.fireworks = { }
  g.gravity = vector_new(0, 0.01)
end

function _update60()
  particle_apply_force(g.firework, g.gravity)
  particle_update(g.firework)
end

function _draw()
  cls()
  particle_show(g.firework)
end

-->8

function particle_new(x, y)
  return {
    pos = vector_new(x, y),
    vel = vector_new(0, -1.5),
    acc = vector_new()
  }
end

function particle_update(particle)
  vector_add_to_ref(particle.vel, particle.acc, particle.vel)
  vector_add_to_ref(particle.pos, particle.vel, particle.pos)
  vector_mult_to_ref(particle.acc, 0, particle.acc)
end

function particle_apply_force(particle, force)
  vector_add_to_ref(particle.acc, force, particle.acc)
end

function particle_show(particle)
  pset(particle.pos.x, particle.pos.y, 7)
end

-->8

function firework_new()
  return {
    firework = particle_new(flr(rnd(127)), 127)
  }
end

function firework_update(firework)
  particle_apply_force(firework, g.gravity)
  particle_update(firework)
end
