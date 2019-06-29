pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_vector3_defined__ = true

-- based on the babylon.js api
vector3_type = { }

function vector3_type:new(x, y, z)
  local o = {
    x = x or 0,
    y = y or 0,
    z = z or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector3_type:to_str()
  return '[' .. self.x .. ' ' .. self.y .. ' ' .. self.z .. ']'
end

function vector3_type.transform(v, m)
  local ref = vector3_type:new()
  vector3_type.transform_to_ref(v, m, ref)
  return ref
end

function vector3_type.transform_to_ref(v, m, ref)
  ref.x = v.x * m[1][1] + v.y * m[2][1] + v.z * m[3][1]
  ref.y = v.x * m[1][2] + v.y * m[2][2] + v.z * m[3][2]
  ref.z = v.x * m[1][3] + v.y * m[2][3] + v.z * m[3][3]
end

function vector3_type.cross(u, v)
  local ref = vector3_type:new()
  vector3_type.cross_to_ref(u, v, ref)
  return ref
end

function vector3_type.cross_to_ref(u, v, ref)
  ref.x = u.y * v.z - u.z * v.y
  ref.y = u.z * v.x - u.x * v.z
  ref.z = u.x * v.y - u.y * v.x
end

function vector3_type.dot(u, v)
  return u.x * v.x + u.y * v.y + u.z * v.z
end
