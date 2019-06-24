pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- implementation runs too slow, need a way to speed it up

g = { }

function _init()
  g.sandpiles = { }
  for i = 1, 128 do
    col = { }
    add(g.sandpiles, col)
    for j = 1, 128 do
      add(col, 0)
    end
  end
  g.nextpiles = { }
  for i = 1, 128 do
    col = { }
    add(g.nextpiles, col)
    for j = 1, 128 do
      add(col, 0)
    end
  end
  ---
  g.sandpiles[64][64] = 32767
end

function _update60()
  for i = 1, 100 do
    topple()
  end
  g.sandpiles[64][64] += 1000
end

function _draw()
  cls(1)
  for i, col in pairs(g.sandpiles) do
    for j, num in pairs(col) do
      local color
      if num == 0 then
        color = 0
      elseif num == 1 then
        color = 14
      elseif num == 2 then
        color = 12
      elseif num == 3 then
        color = 11
      else
        color = 7
      end
      pset(i - 1, j - 1, color)
    end
  end
  print(stat(1), 4, 4, 11)
end

-->8

function topple()
  for x, col in pairs(g.sandpiles) do
    for y, num in pairs(col) do
      if num < 4 then
        g.nextpiles[x][y] = num
      end
    end
  end
  for x, col in pairs(g.sandpiles) do
    for y, num in pairs(col) do
      if num >= 4 then
        g.nextpiles[x][y] = num - 4
        if (x + 1 < 128) g.nextpiles[x + 1][y] += 1
        if (x - 1 >   0) g.nextpiles[x - 1][y] += 1
        if (y + 1 < 128) g.nextpiles[x][y + 1] += 1
        if (x - 1 >   0) g.nextpiles[x][y - 1] += 1
      end
    end
  end
  local temp = g.sandpiles
  g.sandpiles = g.nextpiles
  g.nextpiles = temp
end
