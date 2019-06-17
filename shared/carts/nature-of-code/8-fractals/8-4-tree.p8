pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- from:
-- https://github.com/nature-of-code/noc-examples-processing/tree/master/chp08_fractals/Exercise_8_08_09_TreeArrayListLeaves
-- attempt to do this without objects besides vector

local g = { }

function _init()
  g.tree = { }
  g.leaves = { }
  local b = make_branch(make_vector(64, 128), make_vector(0, -1), 30)
  add(g.tree, b)
end

function _update60()
  for i = #g.tree, 1, -1 do
    local b = g.tree[i]
    branch_update(b)
    if branch_time_to_branch(b) then
      if #g.tree < 1024 then
        add(g.tree, branch_branch(b, 0.083))
        add(g.tree, branch_branch(b, -0.069))
      else
        add(g.leaves, make_leaf(b.vend))
      end
    end
  end
end

function _draw()
  cls(1)
  for b in all(g.tree) do
    branch_render(b)
  end
  for leaf in all(g.leaves) do
    leaf_display(leaf)
  end
  print('branches: ' .. #g.tree, 4, 4, 7)
  print('leaves: ' .. #g.leaves, 4, 11, 7)
end

-->8

function make_branch(l, v, n)
  return {
    growing = true,
    vstart = l:get(),
    vend = l:get(),
    vel = v:get(),
    timerstart = n,
    timer = n
  }
end

function branch_update(b)
  if b.growing then
    b.vend:add(b.vel)
  end
end

function branch_render(b)
  line(b.vstart.x, b.vstart.y, b.vend.x, b.vend.y)
end

function branch_time_to_branch(b)
  b.timer -= 1
  if b.timer < 0 and b.growing then
    b.growing = false
    return true
  else
    return false
  end
end

function branch_branch(b, angle)
  local theta = b.vel:heading()
  local mag = b.vel:mag()
  theta += angle
  local newvel = make_vector(mag * cos(theta), mag * sin(theta))
  return make_branch(b.vend, newvel, b.timerstart * 0.66)
end

function make_leaf(l)
  return {
    pos = l:get()
  }
end

function leaf_display(l)
  circfill(l.pos.x, l.pos.y, 1, 11)
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
    heading = function (self)
      return vector_angle_between(self, make_vector(1, 0))
    end
  }
end
