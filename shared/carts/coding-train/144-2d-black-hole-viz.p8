pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- bookmark at 33:56
-- issues with photo gets to center of black hole, ejects it
-- https://www.youtube.com/watch?v=Iaz9TqYWUmA

#include lib/vector2.p8

local width = 128
local height = 128
local c = 30
local G = 4
local dt = 0.025
local m87
local particles = { }
local start, finish

function _init()
  m87 = black_hole_type:new(64, 64, 1000)
  start = height / 2
  finish = height / 2 - m87.rs * 2.6
  for y = 0, start, 5 do
    add(particles, photon_type:new(width - 5, y))
  end
end

function _update60()
  for p in all(particles) do
    m87:pull(p)
    p:update()
  end
end

function _draw()
  cls(1)
  m87:show()
  -- line(0, start, width, start, 0)
  -- line(0, finish, width, finish, 0)
  for p in all(particles) do
    p:show()
  end
end

-->8

black_hole_type = { }

function black_hole_type:new(x, y, m)
  local o = {
    mass = m
  }
  o.pos = vector2_type:new(x, y)
  o.rs = (2 * G * o.mass) / (c * c)
  setmetatable(o, self)
  self.__index = self
  return o
end

function black_hole_type:pull(photon)
  local force = self.pos:subtract(photon.pos)
  local r = force:length()
  local fg = G * self.mass / (r * r)
  force:set_length(fg)
  photon.vel:add_in_place(force)
  photon.vel:limit_in_place(c)
end

function black_hole_type:show()
  circfill(self.pos.x, self.pos.y, self.rs, 0) -- event horizon
  circ(self.pos.x, self.pos.y, self.rs * 3, 5) -- accretion disk
  circ(self.pos.x, self.pos.y, self.rs * 1.5, 9) -- unstable photon area
end

-->8

photon_type = { }

function photon_type:new(x, y)
  local o = {
    pos = vector2_type:new(x, y),
    vel = vector2_type:new(-c, 0),
    history = { }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function photon_type:update()
  add(self.history, self.pos:copy())
  local delta_v = self.vel:copy()
  delta_v:scale_in_place(dt)
  -- printh(delta_v.x .. ', ' .. delta_v.y, 'log')
  self.pos:add_in_place(delta_v)
  if #self.history > 100 then
    del(self.history, self.history[1])
  end
end

function photon_type:show()
  pset(self.pos.x, self.pos.y, 8)
  -- history
  color(8)
  line(self.history[1].x, self.history[1].y, self.history[1].x, self.history[1].y)
  for v in all(self.history) do
    line(v.x, v.y)
  end
end
