pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

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
