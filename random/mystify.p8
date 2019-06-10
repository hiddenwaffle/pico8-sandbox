pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- Based on:
-- https://www.youtube.com/watch?v=-X_A1Hqj-qA

function _init()
  cls(0)
  t = 0
  t2 = 0
  speed = 3
  lines = {
    make_line(7),
    make_line(12)
  }
end

function _update60()
  t += 1
  if t >= 3 then
    t = 0
    for line in all(lines) do
      line:update()
    end
  end
  t2 += 1
  if t2 >= 60 * 5 then
    t2 = 0
    for line in all(lines) do
      line:rotate_color()
    end
  end
end

function _draw()
  for line in all(lines) do
    line:draw()
  end
end

function make_line(color)
  return {
    color = color,
    points = {
      make_point(rnd(128), rnd(128 - 16) + 8, 1),
      make_point(rnd(128), rnd(128 - 16) + 8, 0.9)
    },
    update = function (self)
      for point in all(self.points) do
        point:update()
      end
    end,
    draw = function (self)
      line(self.points[1].x, self.points[1].y,
           self.points[2].x, self.points[2].y,
           self.color)
    end,
    rotate_color = function (self)
      self.color += 1
      if (self.color > 15) self.color = 0
      if (self.color == 0) self.color = 1
    end
  }
end

function make_point(x, y, d)
  return {
    x = x,
    y = y,
    d = d, -- allows for more visual variation
    dx = speed,
    dy = speed,
    update = function (self)
      self.x += self.dx
      if self.x < 0 then
        self.x = 0
        self.dx = speed * d
      elseif self.x > 127 then
        self.x = 127
        self.dx = -speed * d
      end
      self.y += self.dy
      if self.y < 15 then
        self.y = 15
        self.dy = speed * d
      elseif self.y > 111 then
        self.y = 111
        self.dy = -speed * d
      end
    end
  }
end
