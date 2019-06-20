pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #65.1
-- https://www.youtube.com/watch?v=ZNH0MuQ51m4

#include lib/table.p8:0

g = { }

function _init()
  cls()
  g.tree = tree_type:new()
  for i = 1, 1000 do
    g.tree:add_value(flr(rnd(1000)))
  end
  g.tree:traverse()
  for i = 1, 10 do
    local target = flr(rnd(1000))
    local result = g.tree:search(target)
    if result then
      print('found ' .. target)
    else
      print(target .. ' not found')
    end
  end
end

-- function _update60()
-- end

-- function _draw()
-- end

-->8

tree_type = { }

function tree_type:new()
  local o = {
    root = nil
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function tree_type:traverse()
  self.root:visit()
end

function tree_type:search(val)
  return self.root:search(val)
end

function tree_type:add_value(val)
  local n = node_type:new(val)
  if not self.root then
    self.root = n
  else
    self.root:add_node(n)
  end
end

-- function tree_type:to_string()
--   return self.root:to_string()
-- end

-->8

node_type = { }

function node_type:new(val)
  local o = {
    value = val,
    left = nil,
    right = nil
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function node_type:search(val)
  if self.value == val then
    return self
  elseif val < self.value and self.left then
    return self.left:search(val)
  elseif val > self.value and self.right then
    return self.right:search(val)
  end
  return nil
end

function node_type:visit()
  if self.left then
    self.left:visit()
  end
  print(self.value)
  if self.right then
    self.right:visit()
  end
end

function node_type:add_node(n)
  if n.value < self.value then
    if self.left == nil then
      self.left = n
    else
      self.left:add_node(n)
    end
  elseif n.value > self.value then
    if self.right == nil then
      self.right = n
    else
      self.right:add_node(n)
    end
  end
end

-- todo: this does not wrap
-- function node_type:to_string()
--   local left_to_string = ''
--   if self.left then
--     left_to_string = self.left:to_string()
--   end
--   local right_to_string = ''
--   if self.right then
--     right_to_string = self.right:to_string()
--   end
--   return '{ ' .. self.value .. ', '
--               .. left_to_string .. ', '
--               .. right_to_string .. '} '
-- end
