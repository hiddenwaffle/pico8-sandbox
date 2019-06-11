pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- based on:
-- https://github.com/nature-of-code/noc-examples-processing/tree/master/chp06_agents/NOC_6_08_SeparationAndSeek
-- which says 6.8 but looks like a continuation of 6.7

function _init()
  poke(0x5f2d, 1)
  vehicles = { }
  for i = 1, 20 do
    vehicles[i] = make_vehicle()
  end
end

function _update60() -- todo: runs after _init() and before _draw() ?
  capture_mouse()
  if btnp(5) then
    add(vehicles, make_vehicle())
  end
  for v in all(vehicles) do
    v:apply_behaviors(vehicles)
    v:update()
  end
end

function _draw()
  cls(1)
  for v in all(vehicles) do
    v:display()
  end
  print('press ❎ to add vehicles', 4, 4, 7)
  circ(mouse.x, mouse.y, 4, 6)
end

function capture_mouse()
  mouse = make_vector(stat(32), stat(33))
end

-->8

function make_vehicle()
  local color = 0
  while color == 0 or color == 1 do
    color = flr(rnd(16))
  end
  return {
    color = color,
    position = make_vector(flr(rnd(128)), flr(rnd(128))),
    r = 2,
    maxspeed = 1,
    maxforce = 0.025,
    acceleration = make_vector(0, 0),
    velocity = make_vector(0, 0),
    apply_force = function (self, force)
      self.acceleration:add(force)
    end,
    apply_behaviors = function (self, vehicles) -- todo: shadows global vehicles
      local separate_force = self:separate(vehicles)
      local seek_force = self:seek(make_vector(mouse.x, mouse.y))
      separate_force:mult(2) -- todo: why this one 2
      seek_force:mult(1)     -- and this one 1 ?
      self:apply_force(separate_force)
      self:apply_force(seek_force)
    end,
    seek = function (self, target)
      local desired = vector_sub(target, self.position)
      desired:normalize() -- todo: what happens if commented out?
      desired:mult(self.maxspeed)
      local steer = vector_sub(desired, self.velocity)
      steer:limit(self.maxforce)
      return steer
    end,
    separate = function (self, vehicles) -- todo: shadows global vehicles
      local desiredseparation = self.r * 4 --  todo: was 2 in the original sketch
      local sum = make_vector(0, 0)
      local count = 0
      for other in all(vehicles) do
        local d = vector_dist(self.position, other.position)
        if d > 0 and d < desiredseparation then
          local diff = vector_sub(self.position, other.position)
          diff:normalize()
          diff:mult(1 / d) -- weight by distance
          sum:add(diff)
          count += 1
        end
      end
      if count > 0 then
        sum:mult(1 / count)
        sum:normalize()
        sum:mult(self.maxspeed)
        sum:sub(self.velocity)
        sum:limit(self.maxforce)
      end
      return sum
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.velocity:limit(self.maxspeed)
      self.position:add(self.velocity)
      self.acceleration:mult(0)
    end,
    -- borders = function (self, p)
    --   if self.position.x > p:get_end().x + self.r then
    --     self.position.x = p:get_start().x - self.r
    --     self.position.y = p:get_start().y + (self.position.y - p:get_end().y)
    --   end
    -- end,
    display = function (self)
      circfill(self.position.x , self.position.y,
               self.r,
               self.color)
    end
  }
end

-->8

-- From:
-- https://www.lexaloffle.com/bbs/?pid=52433
-- http://developer.download.nvidia.com/cg/acos.html
function acos(x)
  local negate = (x < 0 and 1.0 or 0.0)
  x = abs(x)
  local ret = -0.0187293
  ret *= x
  ret += 0.0742610
  ret *= x
  ret -= 0.2121144
  ret *= x
  ret += 1.5707288
  ret *= sqrt(1.0 - x)
  ret -= 2 * negate * ret
  ret = negate * 3.14159265358979 + ret
  return ret / (2 * 3.14159265358979) -- map to [0, 1)
end

function vector_div(v, n)
  return make_vector(v.x / n, v.y / n)
end

function vector_add(a, b)
  return make_vector(a.x + b.x, a.y + b.y)
end

function vector_sub(a, b)
  return make_vector(a.x - b.x, a.y - b.y)
end

function vector_angle_between(a, b)
  return acos(a:dot(b) / (a:mag() * b:mag()))
end

function vector_dist(a, b)
  return sqrt((b.x - a.x) ^  2 + (b.y - a.y) ^ 2)
end

function vector_projection(p, a, b)
  local ap = vector_sub(p, a)
  local ab = vector_sub(b, a)
  ab:normalize()
  ab:mult(ap:dot(ab))
  return vector_add(a, ab)
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
    end,
    dot = function (self, v)
      return self.x * v.x + self.y * v.y
    end
  }
end
