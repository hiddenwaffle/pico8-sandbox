pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

local g = { }

function _init()
  g.lines = { }
  local vstart = make_vector(0, 96)
  local vend = make_vector(128, 96)
  add(g.lines, koch_line_type:new(vstart, vend))
end

function _update60()
  if btnp(4) then
    for l in all(g.lines) do
      l:wiggle()
    end
  end
  if btnp(5) then
    generate()
  end
end

function _draw()
  cls(1)
  for l in all(g.lines) do
    l:display()
  end
  print(#g.lines, 4, 4, 7)
  print(stat(0), 4, 11, 7)
  print('press 🅾️ to wiggle', 4, 18, 7)
  print('press ❎ to generate', 4, 25, 7)
end

function generate()
  local next = { }
  for l in all(g.lines) do
    local a = l:koch_a()
    local b = l:koch_b()
    local c = l:koch_c()
    local d = l:koch_d()
    local e = l:koch_e()
    add(next, koch_line_type:new(a, b))
    add(next, koch_line_type:new(b, c))
    add(next, koch_line_type:new(c, d))
    add(next, koch_line_type:new(d, e))
  end
  g.lines = next
end

-->8

koch_line_type = { }

function koch_line_type:new(a, b)
  o = {
    vstart = a:get(),
    vend = b:get()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function koch_line_type:wiggle()
  local vel = vector_random2d()
  self.vstart:add(vel)
  vel = vector_random2d()
  self.vend:add(vel)
end

function koch_line_type:display()
  line(self.vstart.x, self.vstart.y, self.vend.x, self.vend.y, 7)
end

function koch_line_type:koch_a()
  return self.vstart:get()
end

function koch_line_type:koch_b()
  local v = vector_sub(self.vend, self.vstart)
  v:div(3)
  v:add(self.vstart)
  return v
end

function koch_line_type:koch_c()
  local a = self.vstart:get()
  local v = vector_sub(self.vend, self.vstart)
  v:div(3)
  a:add(v)
  v:rotate(-1 / 6) -- 60 degrees
  a:add(v)
  return a
end

function koch_line_type:koch_d()
  local v = vector_sub(self.vstart, self.vend)
  v:div(3)
  v:add(self.vend)
  return v
end

function koch_line_type:koch_e()
  return self.vend:get()
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

function vector_random2d()
  return make_vector(rnd(2) - 1, rnd(2) - 1)
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
    div = function (self, amt)
      self.x /= amt
      self.y /= amt
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
    end,
    rotate = function (self, theta)
      local xtemp = self.x
      self.x = self.x * cos(theta) - self.y * -sin(theta)
      self.y = xtemp * -sin(theta) + self.y * cos(theta)
    end
  }
end
