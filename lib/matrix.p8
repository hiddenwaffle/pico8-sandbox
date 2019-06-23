pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- https://www.youtube.com/watch?v=uSzGdfdOoG8

lib_matrix_defined__ = true

matrix_type = { }

function matrix_type:new(rows, cols)
  local o = {
    rows = rows,
    cols = cols,
    data = { }
  }
  for i = 1, o.rows do
    o.data[i] = { }
    for j = 1, o.cols do
      o.data[i][j] = 0
    end
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

-- multiply matrix by a scalar
function matrix_type:scale(other)
  if type(other) == 'number' then
    for i = 1, self.rows do
      for j = 1, self.cols do
        self.data[i][j] *= other
      end
    end
  else
    assert(false) -- canot mult give element
  end
end

-- apply a function to every element of the matrix
function matrix_type:map(fn)
  for i = 1, self.rows do
    for j = 1, self.cols do
      local val = self.data[i][j]
      self.data[i][j] = fn(val, i, j)
    end
  end
end

-- either a scalar or a matrix of the same size
function matrix_type:add(other)
  if type(other) == 'number' then
    for i = 1, self.rows do
      for j = 1, self.cols do
        self.data[i][j] += other
      end
    end
  elseif getmetatable(other) == matrix_type then
    assert(self.rows == other.rows and
           self.cols == other.cols)
    for i = 1, self.rows do
      for j = 1, self.cols do
        self.data[i][j] += other.data[i][j]
      end
    end
  else
    assert(false) -- cannot add given element
  end
end

-- either a scalar or a matrix of the same size
function matrix_type:mult_by(other)
  if type(other) == 'number' then
    for i = 1, self.rows do
      for j = 1, self.cols do
        self.data[i][j] *= other
      end
    end
  elseif getmetatable(other) == matrix_type then
    assert(self.rows == other.rows and
           self.cols == other.cols)
    for i = 1, self.rows do
      for j = 1, self.cols do
        self.data[i][j] *= other.data[i][j]
      end
    end
  else
    assert(false) -- cannot multiply given element
  end
end

function matrix_type:randomize()
  for i = 1, self.rows do
    for j = 1, self.cols do
      self.data[i][j] = rnd(2) - 1
    end
  end
end

function matrix_type:tostr()
  local str = ''
  for i = 1, self.rows do
    for j = 1, self.cols do
      str = str .. self.data[i][j] .. ' , '
    end
    if (i != self.rows) str = str .. '\n'
  end
  return str
end

function matrix_type:totable()
  local arr = { }
  for i = 1, self.rows do
    for j = 1, self.cols do
      add(arr, self.data[i][j])
    end
  end
  return arr
end

function matrix_type.transpose(m)
  local result = matrix_type:new(m.cols, m.rows)
  for i = 1, m.rows do
    for j = 1, m.cols do
      result.data[j][i] = m.data[i][j]
    end
  end
  return result
end

-- apply a function to every element of the matrix
function matrix_type.map_this(m, fn)
  local result = matrix_type:new(m.rows, m.cols)
  for i = 1, m.rows do
    for j = 1, m.cols do
      local val = m.data[i][j]
      result.data[i][j] = fn(val, i, j)
    end
  end
  return result
end

-- this is different from scale() that takes a scalar
function matrix_type.mult(a, b)
  if getmetatable(a) != matrix_type or
     getmetatable(b) != matrix_type then
    assert(false) -- parameters must be matrices
  end
  assert(a.cols == b.rows)
  local m = matrix_type:new(a.rows, b.cols)
  for i = 1, m.rows do
    for j = 1, m.cols do
      local sum = 0
      for k = 1, a.cols do
        sum += a.data[i][k] * b.data[k][j]
      end
      m.data[i][j] = sum
    end
  end
  return m
end

function matrix_type.subtract(a, b)
  assert(a.rows == b.rows and a.cols == b.cols)
  local result = matrix_type:new(a.rows, a.cols)
  for i = 1, a.rows do
    for j = 1, a.cols do
      result.data[i][j] = a.data[i][j] - b.data[i][j]
    end
  end
  return result
end

function matrix_type.from_table(arr)
  local m = matrix_type:new(#arr, 1)
  for i = 1, #arr do
    m.data[i][1] = arr[i]
  end
  return m
end

-->8

function _init()
  cls()
  -- test_matrix_type_mult()
  test_matrix_type_map()
end

function test_matrix_type_mult()
  local m1 = matrix_type:new(2, 3)
  m1.data[1][1] = 1
  m1.data[1][2] = -1
  m1.data[1][3] = 2
  m1.data[2][1] = 0
  m1.data[2][2] = -3
  m1.data[2][3] = 1
  print(m1:tostr())
  print('\n')
  local m2 = matrix_type:new(3, 1)
  m2.data[1][1] = 2
  m2.data[2][1] = 1
  m2.data[3][1] = 0
  print(m2:tostr())
  print('\n')
  local m3 = matrix_type.mult(m1, m2)
  print(m3:tostr())
  print('\n')
  -- todo: assertions
  m3:scale(5)
  print(m3:tostr())
  print('\n')
  -- todo: assertions
end

function test_matrix_type_map()
  local m1 = matrix_type:new(2, 3)
  m1.data[1][1] = 1
  m1.data[1][2] = -1
  m1.data[1][3] = 2
  m1.data[2][1] = 0
  m1.data[2][2] = -3
  m1.data[2][3] = 1
  print(m1:tostr())
  print('\n')
  m1:map(function (x)
    return x * 2
  end)
  print(m1:tostr())
  print('\n')
  -- todo: assertions
end
