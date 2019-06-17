pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_vector3d_defined_ = true

vector3d_type = { }

function vector3d_type:new(x, y, z)
  local o = {
    x = x or 0,
    y = y or 0,
    z = z or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector3d_type.cross_to_ref(a, b, ref)
  ref.x = a.y * b.z - a.z * b.y
  ref.y = a.z * b.x - a.x * b.z
  ref.z = a.x * b.y - a.y * b.x
  return ref
end
-- local v1 = vector3d_type:new(1, 1, 1)
-- local v2 = vector3d_type:new(0, 0, 1)
-- local result = vector3d_type:new()
-- vector3d_type.cross_to_ref(v1, v2, result)
-- print(result.x .. ', ' .. result.y .. ', ' .. result.z)
