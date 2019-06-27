pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

--[[

p and q are basis vectors.

if p = [1, 0], then p' = [ (cos theta) (sin theta)]
if q = [0, 1], then q' = [-(sin theta) (cos theta)]
            ___  ___   _____                  _____
R(theta) =  | -p'- |   |  (cos theta) (sin theta) |
            | -q'- | = | -(sin theta) (cos theta) |
            |__  __|   |____                  ____|

]]--

#include lib/math.p8:0

local width = 128
local height = 128

g = { }

function _init()
  g.p = { x = 1, y = 0 }
  g.q = { x = 0, y = 1 }
  g.p_prime = { } -- filled in later
  g.q_prime = { } -- filled in later
  g.rotation = {
    { cosine,        sine },
    { negative_sine, cosine}
  }
  g.angle = 0
end

function randomize()
  g.p.x = rnd(4) - 2
  g.p.y = rnd(3) - 1
  g.q.x = rnd(4) - 2
  g.q.y = rnd(3) - 1
end

function cosine(a)
  return cos(a)
end

function sine(a)
  return -sin(a)
end

function negative_sine(a)
  return sin(a)
end

-->8

function _update60()
  g.angle += 0.005
  if (g.angle >= 1) g.angle = 0
  -- multiply p and q by the rotation matrix, given the current angle
  -- equations for this are on page 122 in the book, equation 4.4,
  -- but for 2d instead of 3d.
  -- also notice that these are row vector * matrix, not col vector * matrix.
  --
  -- for derivation of the 2d rotation matrix (similar but rotates opposite direction),
  -- see:
  -- https://www.youtube.com/watch?v=OYuoPTRVzxY
  do
    -- p * rotation = [(x * m11 + y * m21) (x * m12 + y * m22)]
    g.p_prime.x = g.p.x * g.rotation[1][1](g.angle) + g.p.y * g.rotation[2][1](g.angle)
    g.p_prime.y = g.p.x * g.rotation[1][2](g.angle) + g.p.y * g.rotation[2][2](g.angle)
  end
  do
    -- q * rotation = [(x * m11 + y * m21) (x * m12 + y * m22)]
    g.q_prime.x = g.q.x * g.rotation[1][1](g.angle) + g.q.y * g.rotation[2][1](g.angle)
    g.q_prime.y = g.q.x * g.rotation[1][2](g.angle) + g.q.y * g.rotation[2][2](g.angle)
  end
  if btnp(5) then
    randomize()
  end
end

-->8

function _draw()
  cls(1)
  -- grid
  for x = -2, 2 do
    draw_line(x, -1, x, 4, 5)
  end
  for y = -1, 4 do
    draw_line(-2, y, 2, y, 5)
  end
  -- x-y axes
  draw_line(0, -1, 0, 4, 7)
  draw_line(-2, 0, 2, 0, 7)
  -- p and q
  draw_line(0, 0, g.p.x, g.p.y, 9)
  draw_line(0, 0, g.q.x, g.q.y, 10)
  -- p' and q'
  draw_line(0, 0, g.p_prime.x, g.p_prime.y, 11)
  draw_line(0, 0, g.q_prime.x, g.q_prime.y, 12)
  --
  print('angle: ' .. g.angle, 4, 4, 7)
  print('p   ' .. '[' .. g.p.x ..       ' ' .. g.p.y       .. ']', 4, 11, 9)
  print('q   ' .. '[' .. g.q.x ..       ' ' .. g.q.y       .. ']', 4, 18, 10)
  print('p\' ' .. '[' .. g.p_prime.x .. ' ' .. g.p_prime.y .. ']', 4, 25, 11)
  print('q\' ' .. '[' .. g.q_prime.x .. ' ' .. g.q_prime.y .. ']', 4, 33, 12)
  print('press ❎ to randomize', 4, 40, 7)
end

function draw_line(x1, y1, x2, y2, col)
  local px1 = math_map(x1, -2, 2, 0, 127)
  local py1 = math_map(y1, -1, 4, 127, 0)
  local px2 = math_map(x2, -2, 2, 0, 127)
  local py2 = math_map(y2, -1, 4, 127, 0)
  line(px1, py1, px2, py2, col)
end
