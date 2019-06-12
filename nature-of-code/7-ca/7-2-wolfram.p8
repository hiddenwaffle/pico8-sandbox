pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
  cls(1)
  g.delay = 0
  -- todo: only 90 looks right?
  -- local ruleset = {0, 1, 1, 1, 1, 0, 1, 1} -- 222 "uniformity"
  -- local ruleset = {0, 1, 1, 1, 1, 1, 0, 1} -- 190 "repetition"
  -- local ruleset = {0, 1, 1, 1, 1, 0, 0, 0} -- 30 "randomness"
  -- local ruleset = {0, 1, 1, 1, 0, 1, 1, 0} -- 110 unnamed?
  local ruleset = {0, 1, 0, 1, 1, 0, 1, 0} -- 90 "fractal triangle"
  -- local ruleset = {0, 1, 0, 1, 0, 1, 1, 0} -- something that looks more like 30 in the video...?
  g.ca = ca_type:new(ruleset)
end

function _update60()
  if btnp(5) then
    cls(1)
    g.ca:randomize()
    g.ca:restart()
  end
  if not g.ca:finished() then
    g.ca:generate()
  end
end

function _draw()
  g.ca:display()
end

-->8

ca_type = { }

function ca_type:new(r)
  o = {
    ruleset = r,
    cells = { },
    generation = nil, -- todo: 0 instead?
  }
  self.restart(o) -- <--- todo: normal to call this way in constructor?
  setmetatable(o, self)
  self.__index = self
  return o
end

function ca_type:randomize()
  for i = 1, 8 do
    self.ruleset[i] = flr(rnd(2))
  end
end

function reset_130(t)
  for i = 1, 130 do
    t[i] = 0
  end
end

function ca_type:restart()
  reset_130(self.cells)
  self.cells[64] = 1
  self.generation = 0
end

function ca_type:generate()
  local nextgen = { }
  reset_130(nextgen)
  for i = 2, 129 do
    local left  = self.cells[i - 1]
    local me    = self.cells[i]
    local right = self.cells[i + 1]
    nextgen[i]  = self:rules(left, me, right)
  end
  self.cells = nextgen
  self.generation += 1
end

function ca_type:display()
  for i = 1, #self.cells do
    if (self.cells[i] == 1) then
      pset(i - 1, self.generation, 7)
    end
  end
  print(self.ruleset[1] ..
        self.ruleset[2] ..
        self.ruleset[3] ..
        self.ruleset[4] ..
        self.ruleset[5] ..
        self.ruleset[6] ..
        self.ruleset[7] ..
        self.ruleset[8],
        4, 4, 11)
  print('press ❎ to random', 4, 11, 9)
end

function ca_type:rules(a, b, c)
  if (a == 1 and b == 1 and c == 1) return self.ruleset[1]
  if (a == 1 and b == 1 and c == 0) return self.ruleset[2]
  if (a == 1 and b == 0 and c == 1) return self.ruleset[3]
  if (a == 1 and b == 0 and c == 0) return self.ruleset[4]
  if (a == 0 and b == 1 and c == 1) return self.ruleset[5]
  if (a == 0 and b == 1 and c == 0) return self.ruleset[6]
  if (a == 0 and b == 0 and c == 1) return self.ruleset[7]
  if (a == 0 and b == 0 and c == 0) return self.ruleset[8]
  return 0
end

function ca_type:finished()
  return self.generation > 128
end
