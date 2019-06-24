pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
  g.current = { }
  g.previous = { }
  for i = 1, 128 do
    g.current[i] = { }
    g.previous[i] = { }
    for j = 1, 128 do
      g.current[i][j] = 7
      g.previous[i][j] = 7
    end
  end
  g.dampening = 0.999
  g.previous[64][64] = 14
  g.t = 0
end

function _update60()
  g.t += 1
  if g.t > 10 then
    g.t = 0
    local x = flr(rnd(128)) + 1
    local y = flr(rnd(128)) + 1
    local color = flr(rnd(16))
    g.previous[x][y] = color
  end
end

function _draw()
  cls(1)
  for i = 2, 127 do
    for j = 2, 127 do
      g.current[i][j] =
        (g.previous[i - 1][j] +
         g.previous[i + 1][j] +
         g.previous[i][j + 1] +
         g.previous[i][j - 1]) / 2 - g.current[i][j]
      g.current[i][j] *= g.dampening
      pset(i - 1, j - 1, g.current[i][j])
    end
  end
  local temp = g.previous
  g.previous = g.current
  g.current = temp
  print(stat(1), 4, 4, 11)
end
