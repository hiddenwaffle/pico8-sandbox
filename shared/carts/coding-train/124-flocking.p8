pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=mhjuuHl6qHM

#include lib/vector2.p8

width = 128
height = 128
g = { }

function _init()
  g.flock = { }
  for i = 1, 16 do
    add(g.flock, boid_type:new())
  end
  g.factors = {
    ['alignment'] = 1,
    ['cohesion'] = 1,
    ['separation'] = 1
  }
  g.current_factor = 'alignment'
end

function _update60()
  if btn(0) then
    g.factors[g.current_factor] -= 0.05
  end
  if btn(1) then
    g.factors[g.current_factor] += 0.05
  end
  g.factors[g.current_factor] = mid(g.factors[g.current_factor], 0, 5)
  if btnp(2) then
    if g.current_factor == 'alignment' then g.current_factor = 'separation'
    elseif g.current_factor == 'cohesion' then g.current_factor = 'alignment'
    elseif g.current_factor == 'separation' then g.current_factor = 'cohesion'
    end
  end
  if btnp(3) then
    if g.current_factor == 'alignment' then g.current_factor = 'cohesion'
    elseif g.current_factor == 'cohesion' then g.current_factor = 'separation'
    elseif g.current_factor == 'separation' then g.current_factor = 'alignment'
    end
  end
  --
  for boid in all(g.flock) do
    boid:edges()
    boid:flock(g.flock)
    boid:update()
  end
end

function _draw()
  cls(1)
  for boid in all(g.flock) do
    boid:show()
  end
  --
  local cpu = stat(1)
  local cpu_color = cpu >= 1 and 8 or 11
  print(cpu, 4, 4, cpu_color)
  --
  local alignment_color = g.current_factor == 'alignment' and 10 or 12
  print('alignment: ' .. g.factors['alignment'], 4, 11, alignment_color)
  local cohesion_color = g.current_factor == 'cohesion' and 10 or 12
  print('cohesion: ' .. g.factors['cohesion'], 4, 18, cohesion_color)
  local separation_color = g.current_factor == 'separation' and 10 or 12
  print('separation: ' .. g.factors['separation'], 4, 25, separation_color)
end

-->8

boid_type = { }

function boid_type:new()
  local o = {
    position = vector2_type:new(flr(rnd(128)), flr(rnd(128))),
    velocity = vector2_type.random():scale_in_place((rnd(1) + 0.5)),
    acceleration = vector2_type:new(),
    max_force = 0.2,
    max_speed = 1
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function boid_type:edges()
  if self.position.x > width then
    self.position.x = 0
  elseif self.position.x < 0 then
    self.position.x = width
  end
  if self.position.y > height then
    self.position.y = 0
  elseif self.position.y < 0 then
    self.position.y = height
  end
end

function boid_type:align(boids)
  local perception_radius = 20
  local steering = vector2_type:new()
  local total = 0
  for other in all(boids) do
    local d = vector2_type.distance(self.position, other.position)
    if other != self and d < perception_radius then
      steering:add_in_place(other.velocity)
      total += 1
    end
  end
  if total > 0 then
    steering:scale_in_place(1 / total)
    steering:set_length(self.max_speed)
    steering:subtract_in_place(self.velocity)
    steering:limit_in_place(self.max_force)
  end
  return steering
end

function boid_type:cohesion(boids)
  local perception_radius = 20
  local steering = vector2_type:new()
  local total = 0
  for other in all(boids) do
    local d = vector2_type.distance(self.position, other.position)
    if other != self and d < perception_radius then
      steering:add_in_place(other.position)
      total += 1
    end
  end
  if total > 0 then
    steering:scale_in_place(1 / total)
    steering:subtract_in_place(self.position)
    steering:set_length(self.max_speed)
    steering:subtract_in_place(self.velocity)
    steering:limit_in_place(self.max_force)
  end
  return steering
end

function boid_type:separation(boids)
  local perception_radius = 20
  local steering = vector2_type:new()
  local total = 0
  for other in all(boids) do
    local d = vector2_type.distance(self.position, other.position)
    if other != self and d < perception_radius then
      local diff = self.position:subtract(other.position)
      -- if (d != 0) diff:scale_in_place(1 / d)
      if (d != 0) diff:scale_in_place(1 / d ^ 2)
      steering:add_in_place(diff)
      total += 1
    end
  end
  if total > 0 then
    steering:scale_in_place(1 / total)
    steering:set_length(self.max_speed)
    steering:subtract_in_place(self.velocity)
    steering:limit_in_place(self.max_force)
  end
  return steering
end

function boid_type:flock(boids)
  local alignment = self:align(boids)
  local cohesion = self:cohesion(boids)
  local separation = self:separation(boids)
  alignment:scale_in_place(g.factors['alignment'])
  cohesion:scale_in_place(g.factors['cohesion'])
  separation:scale_in_place(g.factors['separation'])
  self.acceleration:add_in_place(alignment)
  self.acceleration:add_in_place(cohesion)
  self.acceleration:add_in_place(separation)
end

function boid_type:update()
  self.position:add_in_place(self.velocity)
  self.velocity:add_in_place(self.acceleration)
  self.velocity:limit_in_place(self.max_speed)
  -- reset acceleration for next frame
  self.acceleration:scale_in_place(0)
end

function boid_type:show()
  circfill(self.position.x, self.position.y, 2, 7)
end
