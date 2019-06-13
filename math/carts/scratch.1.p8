pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include shared.p8

function _init()
  ball = {
    r = 6,
    x = 64,
    y = 64,
    dx = 1,
    dy = 1
  }
end

function _update60()
  ball.x += ball.dx
  ball.y += ball.dy
  if ball.x - ball.r < 0 then
    ball.x = 0 + ball.r
    ball.dx = 1
  elseif ball.x + ball.r > 128 then
    ball.x = 128 - ball.r
    ball.dx = -1
  end
  if ball.y - ball.r < 32 then
    ball.y = 32 + ball.r
    ball.dy = 1
  elseif ball.y + ball.r > 96 then
    ball.y = 96 - ball.r
    ball.dy = -1
  end
end

function _draw()
  cls(1)
  line(0, 32, 128, 32, get_black())
  line(0, 96, 128, 96, get_black())
  circfill(ball.x, ball.y, ball.r, get_cerulean())
  circ(ball.x, ball.y, ball.r, 7)
end
