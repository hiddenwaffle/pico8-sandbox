pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/open-simplex-noise.p8:0
#include lib/vector2d.p8:0

g = { }

function _init()
  camera(-64, -64)
  os2d_noise()
  g.blob = blob_type:new(0, 0, 42)
end

function _update60()
end

function _draw()
  cls(1)
  g.blob:show()
end

-->8

-- this section is copied from the agar.io coding challenge

blob_type = { }

function blob_type:new(x, y, r)
  local o = {
    pos = vector2d_type:new(x, y),
    r = r
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function blob_type:show(player_r)
  local color = 7
  local prev_x = 0
  local prev_y = 0
  local first_x = nil
  local first_y = nil
  local resolution = 30 -- 360
  for i = 1, resolution, 1 do
    local angle = i / resolution
    local offset = os2d_eval(i + t(), angle + t()) * 10
    local r = self.r + offset
    local x = r * cos(angle)
    local y = r * sin(angle)
    if i == 1 then
      first_x = x
      first_y = y
    elseif i == resolution then
      line(x, y, first_x, first_y, color)
    else
      line(x, y, prev_x, prev_y)
    end
    prev_x = x
    prev_y = y
  end
end
