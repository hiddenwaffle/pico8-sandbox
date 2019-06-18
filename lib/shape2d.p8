pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- points should be have keys x and y
function shape2d(points, color, close)
  if (close == nil) close = true
  angle = angle or 0
  for i = 1, #points do
    local x = points[i].x
    local y = points[i].y
    if i == 1 then
      first_x = x
      first_y = y
    else
      line(x, y, prev_x, prev_y, color)
      if close and i == #points then
        line(x, y, first_x, first_y, color)
      end
    end
    prev_x = x
    prev_y = y
  end
end
