pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- Based on:
-- https://www.youtube.com/watch?v=-X_A1Hqj-qA

function _init()
  cls(1)
  lines = {
    make_line(8),
    make_line(11)
  }
end

function _update60()
  for line in all(lines) do
    line:update()
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
      make_point(rnd(128), rnd(128 - 16) + 8, 1, 1),
      make_point(rnd(128), rnd(128 - 16) + 8, -1, -1)
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
    end
  }
end

function make_point(x, y, dx, dy)
  return {
    x = x,
    y = y,
    dx = dx,
    dy = dy,
    update = function (self)
      self.x += self.dx
      if self.x < 0 then
        self.x = 0
        self.dx = 1
      elseif self.x > 127 then
        self.x = 127
        self.dx = -1
      end
      self.y += self.dy
      if self.y < 15 then
        self.y = 15
        self.dy = 1
      elseif self.y > 111 then
        self.y = 111
        self.dy = -1
      end
    end
  }
end
