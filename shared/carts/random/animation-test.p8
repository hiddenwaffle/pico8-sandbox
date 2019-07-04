pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

g = { }

function _init()
  local frames = {
    animation_frame_type:new(1, 10),
    animation_frame_type:new(2, 10),
    animation_frame_type:new(3, 10),
    animation_frame_type:new(2, 10),
    animation_frame_type:new(4, 10),
    animation_frame_type:new(2, 10),
  }
  local animation = animation_type:new(frames)
  g.a_inst = animation_instance_type:new(animation)
end

function _update60()
  g.a_inst:update()
end

function _draw()
  cls(1)
  g.a_inst:draw(64, 64)
end

-->8

animation_instance_type = { }

function animation_instance_type:new(animation)
  local o = {
    animation = animation,
    current_frame_index = 1,
    current_ttl = animation:ttl_for(1)
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function animation_instance_type:draw(x, y)
  local sprite_index = self.animation.frames[self.current_frame_index].index
  local flip = self.animation.frames[self.current_frame_index].flip
  spr(sprite_index, x, y, 1, 1, flip) -- todo: w h
end

function animation_instance_type:update()
  self.current_ttl -= 1
  if self.current_ttl <= 0 then
    self.current_frame_index = self.animation:frame_after(self.current_frame_index)
    if self.current_frame_index == -1 then
      self.animation = self.animation.next
      self.current_frame_index = 1
    end
    self.current_ttl = self.animation:ttl_for(self.current_frame_index)
  end
end

-->8

animation_type = { }

function animation_type:new(frames, next)
  local o = {
    frames = frames
  }
  o.next = next or o
  setmetatable(o, self)
  self.__index = self
  return o
end

function animation_type:flip_for(index)
  return self.frames[index].flip
end

function animation_type:frame_after(index)
  if index < #self.frames then
    return index + 1
  else
    return -1 -- no frames left in this animation
  end
end

function animation_type:ttl_for(index)
  return self.frames[index].ttl
end

-->8

animation_frame_type = { }

function animation_frame_type:new(index, ttl, flip)
  local o = {
    index = index,
    ttl = ttl,
    flip = flip or false
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

__gfx__
00000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700007000000070000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777700777777007777770077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000779779777777777077777770777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777797797777797797797797770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000777777707777777077777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
