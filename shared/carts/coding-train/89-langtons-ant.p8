pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

local antup = 0
local antright = 1
local antdown = 2
local antleft = 3
local width = 128
local height = 128

function _init()
  g.grid = { }
  for i = 1, width do
    g.grid[i] = { }
    for j = 1, height do
      g.grid[i][j] = 0
    end
  end
  g.x = 64
  g.y = 64
  g.dir = antup
end

function _update60()
  for i = 1, 100 do
    local state = g.grid[g.x][g.y]
    if state == 0 then
      turn_right()
      g.grid[g.x][g.y] = 1
      moveForward()
    elseif state == 1 then
      turn_left()
      g.grid[g.x][g.y] = 0
      moveForward()
    end
  end
end

function _draw()
  cls(1)
  for i = 1, width do
    for j = 1, height do
      if g.grid[i][j] == 0 then
        pset(i, j, 3)
      elseif g.grid[i][j] == 1 then
        pset(i, j, 11)
      end
    end
  end
  circfill(g.x, g.y, 1, 8)
  print(stat(0), 4, 4, 7)
end

-->8

function turn_right()
  g.dir += 1
  if g.dir > antleft then
    g.dir = antup
  end
end

function turn_left()
  g.dir -= 1
  if g.dir < antup then
    g.dir = antleft
  end
end

function moveForward()
  if g.dir == antup then
    g.y -= 1
  elseif g.dir == antright then
    g.x += 1
  elseif g.dir == antdown then
    g.y += 1
  elseif g.dir == antleft then
    g.x -= 1
  end
  if g.x >= width then
    g.x = 1
  elseif g.x < 1 then
    g.x = width - 1
  end
  if g.y >= height then
    g.y = 1
  elseif g.y < 1 then
    g.y = height - 1
  end
end
