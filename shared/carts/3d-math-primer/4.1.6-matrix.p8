pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/table.p8:0

g = { }

function _init()
  cls()
  -- square matrix
  g.sm = matrix_type.from_table{
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }}
  -- square matrix's transpose
  g.smt = g.sm:transpose()
  -- back to original
  g.smtt = g.smt:transpose()
  -- 1x3 matrix
  g.m1x3 = matrix_type.from_table{
   { 1 },
   { 2 },
   { 3 }}
  -- 1x3 transposed to 3x1
  g.m1x3t = g.m1x3:transpose()
  -- 2x3 matrix
  -- g.m2x3 = matrix_type:new(2, 3)
  -- g.m2x3[1][1] = 1 ; g.m2x3[1][2] = 2 ; g.m2x3[1][3] = 3
  -- g.m2x3[2][1] = 4 ; g.m2x3[2][2] = 5 ; g.m2x3[2][3] = 6
  g.m2x3 = matrix_type.from_table{
    { 1, 2, 3 },
    { 4, 5, 6 }}
  -- 2x3 matrix scaled
  g.m2x3s = matrix_type:new(2, 3)
  g.m2x3:scale_to_ref(2, g.m2x3s)
  -- 3x2 matrix
  g.m3x2 = matrix_type.from_table{
    { 1, 2 },
    { 3, 4 },
    { 5, 6 }}
  -- product of 2x3 times 3x2 matrices
  g.m2x2 = g.m2x3:multiply(g.m3x2)
  -- visualization page starts at 1
  g.page = 1 -- todo: set back to 1
  g.done = false
end

function _update60()
  if (btnp(5)) g.page += 1
end

function _draw()
  cls(1)
  cursor(4, 4)
  color(6)
  if g.page == 1 then
    print('square matrix:')
    print(g.sm:tostr())
    print('square matrix transposed:')
    print(g.smt:tostr())
    print('square matrix transposed twice:')
    print(g.smtt:tostr())
    print('1x3 matrix:')
    print(g.m1x3:tostr())
    print('1x3 matrix transposed:')
    print(g.m1x3t:tostr())
  elseif g.page == 2 then
    print('2x3 matrix:')
    print(g.m2x3:tostr())
    print('2x3 matrix if scaled:')
    print(g.m2x3s:tostr())
    print('3x2 matrix:')
    print(g.m3x2:tostr())
    print('2x3 times 3x2:')
    print(g.m2x2:tostr())
  else
    g.done = true
  end
  if g.done then
    print('the end', 98, 120, 12)
  else
    print('❎ to turn page', 66, 120, 7)
  end
end

-->8

-- based on the babylon.js api
-- todo: remove assertions? for performance
matrix_type = {
  log = 'log'
}

function matrix_type:multiply(other)
  local m = matrix_type:new(self.rows, other.cols)
  self:multiply_to_ref(other, m)
  return m
end

function matrix_type:multiply_to_ref(other, ref)
  assert(self.rows == ref.rows)
  assert(other.cols == ref.cols)
  assert(self.cols == other.rows)
  for row = 1, ref.rows do
    for col = 1, ref.cols do
      local sum = 0
      for k = 1, self.cols do
        sum += self[row][k] * other[k][col]
      end
      ref[row][col] = sum
    end
  end
end

function matrix_type:new(rows, cols)
  local o = {
    rows = rows,
    cols = cols
  }
  for row = 1, rows do
    o[row] = { }
    for col = 1, cols do
      o[row][col] = 0
    end
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function matrix_type:copy_from(other)
  for row = 1, self.rows do
    for col = 1, self.cols do
      self[row][col] = other[row][col]
    end
  end
  return self
end

function matrix_type:scale(s)
  for row = 1, self.rows do
    for col = 1, self.cols do
      self[row][col] *= s
    end
  end
end

function matrix_type:scale_to_ref(s, ref)
  ref:copy_from(self)
  ref:scale(s)
  return self
end

function matrix_type:tostr()
  str = ''
  for row = 1, self.rows do
    for col = 1, self.cols do
      str = str .. ' ' .. self[row][col]
    end
    if (row != self.rows) str = str .. '\n'
  end
  return str
end


function matrix_type:transpose()
  local m = matrix_type:new(self.cols, self.rows)
  self:transpose_to_ref(m)
  return m
end

function matrix_type:transpose_to_ref(ref)
  for row = 1, self.rows do
    for col = 1, self.cols do
      print(self[row][col])
      assert(self[row][col])
      ref[col][row] = self[row][col]
    end
  end
end

function matrix_type.from_table(t)
  -- ensure rectangle
  local rows = #t
  assert(rows > 0)
  local cols = #t[1]
  for row = 1, rows do
    assert(#t[row] == cols)
  end
  assert(cols > 0)
  -- fill matrix with corresponding value in table
  local m = matrix_type:new(rows, cols)
  for row = 1, rows do
    for col = 1, cols do
      m[row][col] = t[row][col]
    end
  end
  return m
end
