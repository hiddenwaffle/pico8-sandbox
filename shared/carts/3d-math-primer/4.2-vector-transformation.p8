pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- figure 4.2 animation of a basis vector
-- didn't use the vector library, for some reason
-- using linear interpolation in lieu of real transformations

#include lib/math.p8:0

local width = 128
local height = 128

g = { }

function _init()
  g.xhat = { x = 1, y = 0 }
  g.yhat = { x = 0, y = 1 }
  reset()
  g.state = 'done'
  g.book = true -- start with book example first
end

function reset()
  g.state = 'running'
  if g.book then
    -- start with the book example
    g.pfinal = { x =  2, y = 1 } -- always start as xhat
    g.qfinal = { x = -1, y = 2 } -- always start as yhat
    g.book = false
  else
    g.pfinal = rnd_p()
    g.qfinal = rnd_q()
  end
  g.p = { x = g.xhat.x, y = g.xhat.y } -- always start as xhat
  g.q = { x = g.yhat.x, y = g.yhat.y } -- always start as yhat
  g.duration = 60 * 2
  g.time = 0
end

function rnd_p()
  return {
    x = flr(rnd(2)) + 1,
    y = flr(rnd(5))
  }
end

function rnd_q()
  return {
    x = flr(rnd(3)) - 2,
    y = flr(rnd(5))
  }
end

-->8

function _update60()
  if g.state == 'running' then
    update_running()
  elseif g.state == 'done' then
    update_done()
  end
end

function update_running()
  local amt = g.time / g.duration
  g.p.x = lerp(g.xhat.x, g.pfinal.x, amt)
  g.p.y = lerp(g.xhat.y, g.pfinal.y, amt)
  g.q.x = lerp(g.yhat.x, g.qfinal.x, amt)
  g.q.y = lerp(g.yhat.y, g.qfinal.y, amt)
  g.time += 1
  if g.time >= g.duration then
    g.p.x = g.pfinal.x
    g.p.y = g.pfinal.y
    g.q.x = g.qfinal.x
    g.q.y = g.qfinal.y
    g.state = 'done'
  end
end

function update_done()
  if (btnp(5)) reset();
end

function lerp(a, b, amt)
  return a + (b - a) * amt
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
  -- p and q vectors
  local p, q = g.p, g.q
  draw_line(0, 0, p.x, p.y, 11)
  draw_line(0, 0, q.x, q.y, 12)
  -- other parallelogram sizes
  draw_line(p.x, p.y, p.x + q.x, p.y + q.y, 13)
  draw_line(q.x, q.y, q.x + p.x, q.y + p.y, 13)
  --
  if g.state == 'running' then
    draw_running()
  elseif g.state == 'done' then
    draw_done()
  end
  print('p: ' .. p.x .. ', ' .. p.y, 4, 4, 11)
  print('q: ' .. q.x .. ', ' .. q.y, 4, 11, 12)
end

function draw_running()
end

function draw_done()
  if g.book then
    print('press x to start', 4, 21, 10)
  else
    print('press x to randomize', 4, 21, 10)
  end
end

function draw_line(x1, y1, x2, y2, col)
  local px1 = math_map(x1, -2, 2, 0, 127)
  local py1 = math_map(y1, -1, 4, 127, 0)
  local px2 = math_map(x2, -2, 2, 0, 127)
  local py2 = math_map(y2, -1, 4, 127, 0)
  line(px1, py1, px2, py2, col)
end
