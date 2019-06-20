pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #65.2
-- https://www.youtube.com/watch?v=KFEvF_ymuzY&

#include lib/text.p8:0

g = { }

function _init()
  cls(1)
  g.tree = tree_type:new()
  for i = 1, 10 do
    g.tree:add_value(flr(rnd(20)))
  end
  g.tree:traverse()
  cursor(0, 120)
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
  if not self.root then
    local n = node_type:new(val, 64, 6)
    self.root = n
  else
    local n = node_type:new(val)
    self.root:add_node(n)
  end
end

-->8

node_type = { }

function node_type:new(val, x, y)
  local o = {
    value = val,
    left = nil,
    right = nil,
    x = x or 0,
    y = y or 0
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
    line(self.x, self.y + 4, self.left.x, self.left.y - 4, 2)
    self.left:visit()
  end
  text_print_center(self.value, self.x, self.y, 7)
  if self.right then
    line(self.x, self.y + 4, self.right.x, self.right.y - 4, 2)
    self.right:visit()
  end
end

function node_type:add_node(n)
  if n.value < self.value then
    if self.left == nil then
      self.left = n
      self.left.x = self.x - 7
      self.left.y = self.y + 15
    else
      self.left:add_node(n)
    end
  elseif n.value > self.value then
    if self.right == nil then
      self.right = n
      self.right.x = self.x + 7
      self.right.y = self.y + 15
    else
      self.right:add_node(n)
    end
  end
end
