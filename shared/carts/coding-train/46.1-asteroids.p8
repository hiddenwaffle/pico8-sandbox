pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #46.1
-- https://www.youtube.com/watch?v=hacZU523FyM

#include lib/vector2d.p8:0

g = { }

function _init()
  g.ship = ship_type:new()
  g.asteroids = { }
  add(g.asteroids, asteroid_type:new())
end

function _update60()
  if btn(0) then
    g.ship:set_rotation(0.015)
  end
  if btn(1) then
    g.ship:set_rotation(-0.015)
  end
  if not btn(0) and not btn(1) then
    g.ship:set_rotation(0)
  end
  if btn(2) then
    g.ship:boosting(true)
  else
    g.ship:boosting(false)
  end
  g.ship:turn()
  g.ship:update()
  g.ship:edges()
end

function _draw()
  cls(0)
  g.ship:render()
  for asteroid in all(g.asteroids) do
    asteroid:render()
  end
end

-->8

ship_type = { }

function ship_type:new()
  local o = {
    pos = vector2d_type:new(64, 64),
    r = 3,
    heading = 0,
    rotation = 0,
    vel = vector2d_type:new(),
    is_boosting = false
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function ship_type:boosting(b)
  self.is_boosting = b
end

function ship_type:update()
  if (self.is_boosting) self:boost()
  self.pos:add(self.vel)
  self.vel:mult(0.99)
end

function ship_type:boost()
  local force = vector2d_type.from_angle(self.heading)
  force:mult(0.02)
  self.vel:add(force)
end

function ship_type:render()
  local x_front = self.pos.x + 2 * self.r * cos(self.heading)
  local y_front = self.pos.y + 2 * self.r * sin(self.heading)
  local x_left  = self.pos.x + 2 * self.r * cos(self.heading + 0.33)
  local y_left  = self.pos.y + 2 * self.r * sin(self.heading + 0.33)
  local x_right = self.pos.x + 2 * self.r * cos(self.heading + 0.66)
  local y_right = self.pos.y + 2 * self.r * sin(self.heading + 0.66)
  line(x_front, y_front, x_left, y_left, 12)
  line(x_front, y_front, x_right, y_right, 12)
  line(x_left, y_left, x_right, y_right, 12)
  pset(x_front, y_front, 9)
end

function ship_type:edges()
  if self.pos.x > 128 + self.r then
    self.pos.x = -self.r
  elseif self.pos.x < -self.r then
    self.pos.x = 128 + self.r
  end
  if self.pos.y > 128 + self.r then
    self.pos.y = -self.r
  elseif self.pos.y < -self.r then
    self.pos.y = 128 + self.r
  end
end

function ship_type:set_rotation(a)
  self.rotation = a
end

function ship_type:turn()
  self.heading += self.rotation
end

-->8

asteroid_type = { }

function asteroid_type:new()
  local o = {
    pos = vector2d_type:new(flr(rnd(128), flr(rnd(128)))),
    r = 25
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function asteroid_type:render()
  circ(self.pos.x, self.pos.y, self.r, 6)
end
