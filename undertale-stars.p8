pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  g_heart = {
    x = 60, -- (128 / 2) - (8 / 2) = 60
    y = 55
  }
  g_stars = { }
  for i = 1, 100 do
    g_stars[i] = create_stars()
  end
  g_star_count_target = 10
  g_health = 100 -- 0 to 100
end

function create_stars()
  local star = { }
  reset_star(star)
  return star
end

function reset_star(star)
  star.active = false
  star.frame = 0 -- 0, 1, 2
  star.x = 0
  star.y = 0
  star.dx = 0
  star.dy = 0
end

function _update60()
  update_player()
  update_stars()
  check_collision()
end

function update_player()
  local dx = 0
  local dy = 0
  if (btn(0)) dx = -2
  if (btn(1)) dx =  2
  if (btn(2)) dy = -2
  if (btn(3)) dy =  2
  g_heart.x += dx
  g_heart.y += dy
end

function update_stars()
  animate_stars()
  move_stars()
  gravitate_stars()
  cleanup_stars()
  activate_stars()
end

function animate_stars()
  for star in all(g_stars) do
    if star.active then
      star.frame += 0.5
      if (star.frame > 2) star.frame = 0
    end
  end
end

function move_stars()
  for star in all(g_stars) do
    if star.active then
      star.x += star.dx
      star.y += star.dy
    end
  end
end

function gravitate_stars()
  for star in all(g_stars) do
    star.dy += 0.03
  end
end

function cleanup_stars()
  local current = 0
  for star in all(g_stars) do
    if star.x < 0 or
       star.x > 128 or
       star.y < -32 or -- if one goes too high
       star.y > 128 then
      reset_star(star)
    end
  end
  return current
end

function activate_stars()
  local active = count_active_stars()
  local to_be_activated = g_star_count_target - active
  if (to_be_activated <= 0) return
  for star in all(g_stars) do
    if not star.active then
      activate_star(star)
      to_be_activated -= 1
      if (to_be_activated <= 0) break
    end
  end
end

function activate_star(star)
  star.active = true
  local side = flr(rnd(3)) -- 3 possible sides
  if side == 0 then -- left
    star.x = 0
    star.y = flr(rnd(128))
    star.dx = 1
    star.dy = rnd(1) * -1
  elseif side == 1 then -- right
    star.x = 128
    star.y = flr(rnd(128))
    star.dx = -1
    star.dy = rnd(1) * -1
  else -- bottom
    star.x = flr(rnd(128)) + 1
    star.y = 128
    star.dx = 1 - rnd(2)
    star.dy = -2.75 + rnd(1) - 0.5
  end
end

function count_active_stars()
  local count = 0
  for star in all(g_stars) do
    if (star.active) count += 1
  end
  return count
end

function check_collision()
  for star in all(g_stars) do
    if heart_overlap(star) then
      handle_collision(star)
    end
  end
end

-- hitboxes slightly smaller than 8x8
-- modified from: https://www.geeksforgeeks.org/find-two-rectangles-overlap/
function heart_overlap(star)
  local l1_x = g_heart.x + 1
  local l1_y = g_heart.y + 1
  local r1_x = g_heart.x + 6
  local r1_y = g_heart.y + 6
  local l2_x = star.x + 1
  local l2_y = star.y + 1
  local r2_x = star.x + 6
  local r2_y = star.y + 6
  if (l1_x > r2_x or l2_x > r1_x) return false
  if (l1_y > r2_y or l2_y > r1_y) return false
  return true
end

function handle_collision(star)
  g_health -= 10
  -- todo: handle g_health <= 0
  reset_star(star)
end

function _draw()
  cls(1)
  draw_health()
  draw_player()
  draw_stars()
end

function draw_player()
  spr(1, g_heart.x, g_heart.y)
end

function draw_stars()
  for star in all(g_stars) do
    if star.active then
      spr(2 + flr(star.frame), star.x, star.y)
    end
  end
end

-- 128 - 100 = 28
-- 28 / 7 = 14
function draw_health()
  local offset = g_health -- assumes 0 <= g_health <= 100
  rectfill(14, 119, 14 + 100,    123,  8) -- red
  rectfill(14, 119, 14 + offset, 123, 10) -- yellow
end

__gfx__
00000000080000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888008880c0000c0000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888880070070000070000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008888888800077000000777c00c7770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888000770000c777000000777c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700088888800070070000007000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000c0000c00000c000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
