pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #29
-- https://www.youtube.com/watch?v=bGz7mv2vD6g

g = { }

function _init()
  g.generation = 0
  g.lifespan = 200
  g.max_force = 0.1
  g.count = 1
  g.target = vector_type:new(64, 16)
  g.obstacles = {
    { -- middle
      x = 32,
      y = 56,
      w = 64,
      h = 4
    },
    { -- left
      x = 12,
      y = 32,
      w = 32,
      h = 4
    },
    { -- right
      x = 82,
      y = 32,
      w = 32,
      h = 4
    }
  }
  g.current_maxfit = 0
  g.population = population_type:new()
end

function _update60()
  g.population:run()
  g.count += 1
  if g.count >= g.lifespan then
    g.population:evaluate()
    g.population:selection()
    g.count = 1
    g.generation += 1
  end
end

function _draw()
  cls(1)
  g.population:show()
  circfill(g.target.x, g.target.y, 4, 3)
  circ(g.target.x, g.target.y, 4, 11)
  for obstacle in all(g.obstacles) do
    rectfill(obstacle.x, obstacle.y,
             obstacle.x + obstacle.w, obstacle.y + obstacle.h,
             9)
    rect(obstacle.x, obstacle.y,
         obstacle.x + obstacle.w, obstacle.y + obstacle.h,
         0)
  end
  print(stat(0), 4, 4, 7)
  print('gen: ' .. g.generation, 4, 11, 7)
end

-->8

population_type = { }

function population_type:new()
  local o = {
    rockets = { },
    popsize = 100,
    mating_pool = { }
  }
  for i = 1, o.popsize do
    o.rockets[i] = rocket_type:new()
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function population_type:run()
  for rocket in all(self.rockets) do
    rocket:update()
  end
end

function population_type:evaluate()
  local maxfit = 0
  for rocket in all(self.rockets) do
    rocket:calc_fitness()
    if rocket.fitness > maxfit then
      maxfit = rocket.fitness
    end
  end
  g.current_maxfit = maxfit
  for rocket in all(self.rockets) do
    rocket.fitness /= maxfit
  end
  self.mating_pool = { }
  for rocket in all(self.rockets) do
    local n = flr(rocket.fitness * 100)
    if (n <= 0) n = 1
    for j = 1, n do
      add(self.mating_pool, rocket)
    end
  end
end

function population_type:selection()
  local new_rockets = { }
  for rocket in all(self.rockets) do
    local index_a = flr(rnd(#self.mating_pool)) + 1
    local parent_a = self.mating_pool[index_a].dna
    local index_b = flr(rnd(#self.mating_pool)) + 1
    local parent_b = self.mating_pool[index_b].dna
    local child = parent_a:crossover(parent_b)
    child:mutation()
    add(new_rockets, rocket_type:new(child))
  end
  self.rockets = new_rockets
end

function population_type:show()
  for rocket in all(self.rockets) do
    rocket:show()
  end
end

-->8

dna_type = { }

function dna_type:new(genes)
  local o = { }
  if genes then
    o.genes = genes
  else
    o.genes = { }
    for i = 1, g.lifespan do
      o.genes[i] = self:_random()
    end
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function dna_type:crossover(partner)
  local newgenes = { }
  local mid = flr(rnd(#self.genes)) + 1
  for i = 1, #self.genes do
    if i > mid then
      newgenes[i] = self.genes[i]
    else
      newgenes[i] = partner.genes[i]
    end
  end
  return dna_type:new(newgenes)
end

function dna_type:mutation()
  for gene in all(genes) do
    if rnd(1) < 0.02 then
      gene = self:_random()
      gene:set_mag(g.max_force)
    end
  end
end

function dna_type._random()
  local v = vector_type.random_vector()
  v:set_mag(g.max_force)
  return v
end

-->8

rocket_type = { }

function rocket_type:new(dna)
  local o = {
    pos = vector_type:new(64, 127),
    vel = vector_type:new(),
    acc = vector_type:new(),
    fitness = 0,
    completed = false,
    crashed = false,
    dna = dna or dna_type:new()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function rocket_type:apply_force(force)
  self.acc:add(force)
end

function dist(x1, y1, x2, y2)
  local scaledx = (x2 - x1) * 0.01 -- due to possible overflow
  local scaledy = (y2 - y1) * 0.01 -- due to possible overflow
  return sqrt(scaledx ^ 2 + scaledy ^ 2)
end

function rocket_type:update()
  local d = dist(self.pos.x, self.pos.y, g.target.x, g.target.y)
  -- printh(d, 'log')
  if d < 0.075 then -- was weighted in dist()
    self.completed = true
    -- self.pos = g.target:copy() -- looks cooler without this line
  end
  for obstacle in all(g.obstacles) do
    if self.pos.x > obstacle.x and self.pos.x < obstacle.x + obstacle.w and
       self.pos.y > obstacle.y and self.pos.y < obstacle.y + obstacle.h then
      self.crashed = true
    end
  end
  self:apply_force(self.dna.genes[g.count])
  if not self.completed and not self.crashed then
    self.vel:add(self.acc)
    self.pos:add(self.vel)
    self.acc:mult(0)
  end
end

function rocket_type:calc_fitness()
  if self.completed then
    self.fitness = 1
  elseif self.crashed then
    self.fitness /= 10
  else
    local d = dist(self.pos.x, self.pos.y, g.target.x, g.target.y)
    if (d == 0) d = 0.001
    self.fitness = 1 / d -- todo: not sure how p5's map() works, so doing this instead
  end
end

function rocket_type:show()
  circfill(self.pos.x, self.pos.y, 3, 7)
  circ(self.pos.x, self.pos.y, 3, 0)
end

-->8

vector_type = { }

function vector_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector_type:add(other)
  self.x += other.x
  self.y += other.y
end

function vector_type:mult(amt)
  self.x *= amt
  self.y *= amt
end

function vector_type:magnitude_sq()
  return self.x ^ 2 + self.y ^ 2
end

function vector_type:magnitude()
  return sqrt(self:magnitude_sq())
end

function vector_type:set_mag(amt)
  self:normalize()
  self:mult(amt)
end

function vector_type:normalize()
  local m = self:magnitude()
  if (m == 0) m = 0.0001 -- bandaid
  self.x /= m
  self.y /= m
end

function vector_type:copy()
  return vector_type:new(self.x, self.y)
end

function vector_type.random_vector()
  local v = vector_type:new(rnd(2) - 1, rnd(2) - 1) -- good enough
  v:normalize()
  return v
end
