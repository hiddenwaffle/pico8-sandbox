pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
  g.n = 8
  addqueen({ }, 1)
end

function isplaceok(a, n, c)
  for i = 1, n - 1 do
    if (a[i] == c) or
       (a[i] - i == c -n ) or
       (a[i] + i == c + n) then
      return false
    end
  end
  return true
end

function printsolution(a)
  for i = 1, g.n do
    local str = ''
    for j = 1, g.n do
      str = str .. (a[i] == j and 'x' or '-') .. ' '
    end
    print(str .. '\n')
  end
  print('\n')
end

function addqueen(a, n)
  if n > g.n then
    printsolution(a)
  else
    for c = 1, g.n do
      if isplaceok(a, n, c) then
        a[n] = c
        addqueen(a, n + 1)
      end
    end
  end
end
