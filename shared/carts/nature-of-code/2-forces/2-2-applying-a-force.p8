pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=MkXoQVWRDJs

#include lib/vector2.p8

local m
local width = 128
local height = 128
local gravity = vector2_type:new(0, 0.3)
local wind = vector2_type:new(0.2, 0)

function _init()
  m = mover_type:new()
end

function _update60()
  local f = vector2_type:new()
  m:apply_force(gravity)
  if (btn(5)) m:apply_force(wind)
  m:update()
  m:edges()
end

function _draw()
  cls(1)
  m:display()
  print('press x to simulate wind', 4, 4, 7)
end

-->8

mover_type = { }

function mover_type:new()
  local o = {
    location = vector2_type:new(width / 2, height / 2),
    velocity = vector2_type:new(),
    acceleration = vector2_type:new()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function mover_type:apply_force(force)
  self.acceleration:add_in_place(force)
end

function mover_type:update()
  self.velocity:add_in_place(self.acceleration)
  self.location:add_in_place(self.velocity)
  self.acceleration:scale_in_place(0)
  -- self.velocity:limit_in_place(5)
end

function mover_type:display()
  circfill(self.location.x, self.location.y, 8, 11)
  circ(self.location.x, self.location.y, 8, 7)
end

function mover_type:edges()
  if self.location.x > width then
    self.location.x = width
    self.velocity.x *= -1
  elseif self.location.x < 0 then
    self.location.x = 0
    self.velocity.x *= -1
  end
  if self.location.y > height then
    self.location.y = height
    self.velocity.y *= -1
  end
end
