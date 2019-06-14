pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #3
-- https://www.youtube.com/watch?v=AaGK-fj-BAM

-- 32x32

g = { }

function _init()
  restart()
end

function restart()
  g.state = 'play'
  g.t = 0
  g.s = snake_new()
  g.scl = 4
  pick_location()
end

function _update60()
  if g.state == 'play' then
    update_play()
  elseif g.state == 'done' then
    update_done()
  end
end

function update_play()
  if btn(0) then -- left
    snake_dir(g.s, -1, 0)
  elseif btn(1) then -- right
    snake_dir(g.s, 1, 0)
  elseif btn(2) then -- up
    snake_dir(g.s, 0, -1)
  elseif btn(3) then -- down
    snake_dir(g.s, 0, 1)
  end
  g.t += 1
  if (g.t < 6) return
  g.t = 0
  snake_update(g.s)
  check_lose()
end

function update_done()
  if btn(5) then
    restart()
  end
end

function _draw()
  if g.state == 'play' then
    draw_play()
  elseif g.state == 'done' then
    print('press x for new game', 4, 4, 12)
  end
end

function draw_play()
  cls(1)
  snake_show(g.s)
  rectfill(g.food.x * g.scl, g.food.y * g.scl,
           g.food.x * g.scl + g.scl - 1, g.food.y * g.scl + g.scl - 1, 14)
end

-->8

function snake_new()
  return {
    x = 0,
    y = 0,
    xspeed = 1,
    yspeed = 0,
    lengthen_wait = 0,
    body = {
      { x = 0, y = 0}
    },
  }
end

function snake_dir(snake, x, y)
  if #snake.body > 1 then -- prevent moving in reverse if > 1
    local xdest = snake.body[1].x + x
    local ydest = snake.body[1].y + y
    if xdest == snake.body[2].x and
       ydest == snake.body[2].y then
      -- keep it going forward
      x = snake.xspeed
      y = snake.yspeed
    end
  end
  snake.xspeed = x
  snake.yspeed = y
end

function snake_update(snake)
  -- do length first, if any
  if snake.lengthen_wait > 1 then
    snake.lengthen_wait -= 1
  elseif snake.lengthen_wait == 1 then
    snake.lengthen_wait -= 1
    add(snake.body, { x = snake.body[1].x, y = snake.body[1].y })
  end
  -- shift positions
  local newx = mid(snake.body[1].x + snake.xspeed, 0, 31)
  local newy = mid(snake.body[1].y + snake.yspeed, 0, 31)
  for i = #snake.body, 2, -1 do
    snake.body[i].x = snake.body[i - 1].x
    snake.body[i].y = snake.body[i - 1].y
  end
  snake.body[1].x = newx
  snake.body[1].y = newy
  if snake_eat(g.s, g.food) then
    snake.lengthen_wait = #snake.body + 1
    pick_location()
  end
end

function snake_eat(snake, food)
  if snake.body[1].x == food.x and
     snake.body[1].y == food.y then
    return true
  end
end

function snake_show(snake)
  for s in all(snake.body) do
    rectfill(s.x * g.scl, s.y * g.scl,
             s.x * g.scl + g.scl - 1, s.y * g.scl + g.scl - 1, 7)
  end
end

-->8

function pick_location()
  g.food = {
    x = flr(rnd(32)),
    y = flr(rnd(32))
  }
end

function check_lose()
  for i = 2, #g.s.body do
    local s = g.s.body[i]
    if g.s.body[1].x == s.x and
       g.s.body[1].y == s.y then
      g.state = 'done'
    end
  end
end
