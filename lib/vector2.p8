pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_vector2_defined__ = true

-- based on the babylon.js api
vector2_type = { }

function vector2_type:add_in_place(other)
  self.x += other.x
  self.y += other.y
  return self
end

function vector2_type:copy()
  return vector2_type:new(self.x, self.y)
end

function vector2_type:equals(other)
  return self.x == other.x and self.y == other.y
end

function vector2_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector2_type:subtract_in_place(other)
  self.x -= other.x
  self.y -= other.y
  return self
end

function vector2_type:to_str()
  return '[' .. self.x .. ' ' .. self.y .. ']'
end

function vector2_type.lerp(v1, v2, amt)
  -- todo: one allocation instead of two
  local d = v2:copy():subtract_in_place(v1):scale(amt)
  return v1:copy():add(d)
end

-- todo: lerp_to_ref() ?

function vector2_type:scale_in_place(s)
  self.x *= s
  self.y *= s
  return self
end

function vector2_type.from_angle(a)
  return vector2_type:new(cos(a), sin(a))
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
