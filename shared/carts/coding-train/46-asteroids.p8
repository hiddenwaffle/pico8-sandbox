pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #46.1 and #46.2
-- https://www.youtube.com/watch?v=hacZU523FyM
-- https://www.youtube.com/watch?v=xTTuih7P0c0

#include lib/vector2d.p8:0
#include lib/shape2d.p8:0

g = { }

function _init()
  restart()
end

function restart()
  g.state = 'playing'
  g.ship = ship_type:new()
  g.asteroids = { }
  for i = 1, 5 do
    add(g.asteroids, asteroid_type:new())
  end
  g.lasers = { }
end

function _update60()
  if g.state == 'playing' then
    update_playing()
  elseif g.state == 'game_over' then
    update_game_over()
  end
end

function update_playing()
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
  if btn(3) then
    g.ship:breaking(true)
  else
    g.ship:breaking(false0)
  end
  if btnp(4) or btnp(5) then
    add(g.lasers, laser_type:new(g.ship.pos, g.ship.heading))
  end
  g.ship:turn()
  g.ship:update()
  g.ship:edges()
  for asteroid in all(g.asteroids) do
    if g.ship:hits(asteroid) then
      g.state = 'game_over'
    end
    asteroid:update()
    asteroid:edges()
  end
  for laser in all(g.lasers) do
    laser:update()
    local new_asteroids = { }
    for asteroid in all(g.asteroids) do
      if laser:hits(asteroid) then
        if asteroid.r > 1 then
          local a, b = asteroid:breakup()
          add(new_asteroids, a)
          add(new_asteroids, b)
        end
        del(g.asteroids, asteroid)
        del(g.lasers, laser)
      end
    end
    for new_asteroid in all(new_asteroids) do
      add(g.asteroids, new_asteroid)
    end
  end
end

function update_game_over()
  if btnp(5) then
    restart()
  end
end

function _draw()
  if g.state == 'playing' then
    draw_playing()
  elseif g.state == 'game_over' then
    draw_gameover()
  end
end

function draw_playing(background_color)
  cls(background_color or 0)
  g.ship:render()
  for asteroid in all(g.asteroids) do
    asteroid:render()
  end
  for laser in all(g.lasers) do
    laser:render()
  end
  print(stat(0), 4, 4, 7)
  print(stat(1), 4, 11, 7)
  print(#g.asteroids, 4, 18, 7)
end

function draw_gameover()
  draw_playing(2)
  print('game over! press x to restart', 6, 64, 7)
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
    is_boosting = false,
    is_breaking = false
  }
  self.edges = edges -- duck typing?
  setmetatable(o, self)
  self.__index = self
  return o
end

function ship_type:boosting(b)
  self.is_boosting = b
end

function ship_type:breaking(b)
  self.is_breaking = b
end

function ship_type:update()
  if (self.is_boosting) self:boost()
  self.pos:add(self.vel)
  if (self.is_breaking) then
    self.vel:mult(0.90)
  else
    self.vel:mult(0.99)
  end
end

function ship_type:boost()
  local force = vector2d_type.from_angle(self.heading)
  force:mult(0.02)
  self.vel:add(force)
end

function ship_type:hits(asteroid)
  local d = vector2d_type.dist_16bit(self.pos, asteroid.pos)
  return d < self.r + asteroid.r + asteroid.average_offset
  -- (using average offset to be err on side of player)
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

function ship_type:set_rotation(a)
  self.rotation = a
end

function ship_type:turn()
  self.heading += self.rotation
end

-->8

asteroid_type = { }

function asteroid_type:new(pos, r)
  local o = {
    r = r or flr(rnd(5)) + 5,
    vel = vector2d_type:random_vector(),
    total = flr(rnd(10)) + 5,
    offset = { },
    largest_offset = 0
  }
  if pos then
    o.pos = pos:copy()
  else
    o.pos = vector2d_type:new(rand_away_from_center(), rand_away_from_center())
  end
  o.vel:mult(0.15)
  local offset_sum = 0
  for i = 1, o.total do
    o.offset[i] = flr(o.r * 2) - o.r
    -- do this for collision detection later
    if o.offset[i] > o.largest_offset then
      o.largest_offset = o.offset[i]
    end
    offset_sum += o.offset[i]
  end
  o.average_offset = flr(offset_sum / #o.offset)
  self.edges = edges -- duck typing?
  setmetatable(o, self)
  self.__index = self
  return o
end

function asteroid_type:update()
  self.pos:add(self.vel)
end

function asteroid_type:render()
  local points = { }
  local color = 6
  for i = 1, self.total do
    local angle = i / self.total
    local r = self.r + self.offset[i]
    local x = self.pos.x + r * cos(angle)
    local y = self.pos.y + r * sin(angle)
    add(points, { x = x, y = y })
  end
  shape2d(points, 10)
end

function asteroid_type:breakup()
  local a = asteroid_type:new(self.pos, self.r * 0.5)
  local b = asteroid_type:new(self.pos, self.r * 0.5)
  return a, b
end

-->8

laser_type = { }

function laser_type:new(spos, angle)
  local o = {
    pos = spos:copy(),
    vel = vector2d_type.from_angle(angle)
  }
  o.vel:mult(3)
  setmetatable(o, self)
  self.__index = self
  return o
end

function laser_type:hits(asteroid)
  local d = vector2d_type.dist_16bit(self.pos, asteroid.pos)
  return d < asteroid.r + asteroid.largest_offset
end

function laser_type:update()
  self.pos:add(self.vel)
end

function laser_type:render()
  pset(self.pos.x, self.pos.y, 9)
end

-->8

function edges(self)
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

function rand_away_from_center()
  local sign = 1
  if rnd(1) < 0.5 then
    sign = -1
  end
  return (sign * 64) + (sign * (flr(rnd(32))) + 32)
end
