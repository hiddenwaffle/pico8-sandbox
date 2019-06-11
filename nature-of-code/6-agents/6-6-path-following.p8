pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  configure_path()
  cars = { }
  for i = 1, 16 do
    cars[i] = make_vehicle(make_vector(0, 64), 0.5 + i * 0.0925, 0.01875 + i * 0.003515625)
  end
  move_right = make_vector(0.01, 0)
end

function configure_path()
  path = make_path()
  path:add_point(-1, 64)
  path:add_point(flr(rnd(64)), flr(rnd(128)))
  path:add_point(flr(rnd(64) + 64), flr(rnd(128)))
  path:add_point(128 + 1, 64)
end

function _update60()
  if (btnp(5)) configure_path()
  for car in all(cars) do
    car:follow(path)
    car:apply_force(move_right) -- todo: not sure why i could not find this in the original sketch
    car:update()
    car:borders(path)
  end
end

function _draw()
  cls(1)
  path:display()
  for car in all(cars) do
    car:display()
  end
  print('press ❎ to reconfigure', 4, 4, 7)
end

-->8

function make_path()
  return {
    radius = 5,
    points = { },
    pstart = make_vector(0, 42),
    pend = make_vector(128, 42),
    add_point = function (self, x, y)
      add(self.points, make_vector(x, y))
    end,
    display = function (self)
      line(self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, 13)
      line(self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, 13)
      line(self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, 13)
    end,
    get_start = function (self)
      return self.points[1]
    end,
    get_end = function (self)
      return self.points[#self.points]
    end
  }
end

-->8

function make_vehicle(l, ms, mf)
  local color = 0
  while color != 1 do
    color = flr(rnd(16))
  end
  return {
    color = flr(rnd(16)),
    position = l:get(),
    r = 3,
    maxspeed = ms, -- 1,
    maxforce = mf, -- 0.025,
    acceleration = make_vector(0, 0),
    velocity = make_vector(0, 0),
    follow = function (self, p)
      local predict = self.velocity:get()
      predict:normalize()
      predict:set_mag(20)
      local predict_pos = vector_add(self.position, predict)
      local normal
      local target
      local world_record = 32767
      for i = 1, #p.points - 1 do
        local a = p.points[i]
        local b = p.points[i + 1]
        local normal_point = vector_projection(predict_pos, a, b)
        if normal_point.x < a.x or normal_point.x > b.x then
          normal_point = b:get()
        end
        local distance = vector_dist(predict_pos, normal_point)
        if distance < world_record then
          world_record = distance
          normal = normal_point
          local dir = vector_sub(b, a)
          dir:normalize()
          dir:mult(5)
          target = normal_point:get()
          target:add(dir)
        end
      end
      if world_record > p.radius then
        self:seek(target)
      end
    end,
    apply_force = function (self, force)
      self.acceleration:add(force)
    end,
    seek = function (self, target)
      local desired = vector_sub(target, self.position)
      desired:normalize() -- todo: what happens if commented out?
      desired:mult(self.maxspeed)
      local steer = vector_sub(desired, self.velocity)
      steer:limit(self.maxforce)
      self:apply_force(steer)
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.velocity:limit(self.maxspeed)
      self.position:add(self.velocity)
      self.acceleration:mult(0)
    end,
    borders = function (self, p)
      if self.position.x > p:get_end().x + self.r then
        self.position.x = p:get_start().x - self.r
        self.position.y = p:get_start().y + (self.position.y - p:get_end().y)
      end
    end,
    display = function (self)
      -- todo: draw a triangle using self.r
      rect(self.position.x - 1, self.position.y -1,
           self.position.x + 1, self.position.y + 1,
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
