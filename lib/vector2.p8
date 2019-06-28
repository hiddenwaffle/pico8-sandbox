pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_vector2_defined__ = true

-- based on the babylon.js api
vector2_type = { }

function vector2_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector2_type:to_str()
  return '[' .. self.x .. ' ' .. self.y .. ']'
end

function vector2_type.transform(v, m)
  local ref = vector2_type:new()
  vector2_type.transform_to_ref(v, m, ref)
  return ref
end

function vector2_type.transform_to_ref(v, m, ref)
  ref.x = v.x * m[1][1] + v.y * m[2][1]
  ref.y = v.x * m[1][2] + v.y * m[2][2]
end
