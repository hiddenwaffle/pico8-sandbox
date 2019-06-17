pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- running a max-integer loop every frame
--
-- findings:
-- everything commented out   -  0.4839
-- ^                          -  0.9526
-- sqrt()                     - 19.5852
-- if                         -  0.9526
-- if-else                    -  3.2673
-- if-elseif-else             -  4.2048
-- if, if, if                 -  5.9626
-- distance formula           - 43.7979
-- distance formula squared   - 19.5852
--    ^----- this works out to about 50 entity (n^2) dist_sq comparisons before 100% cpu utilization

#include lib/vector3d.p8:0

function _init()
end

function _update60()
  local x = 0
  for i = 1, 32767 do
    -- begin test sections

    -- -- test ---- exponentiation
    -- x += 10 ^ 10

    -- -- test ---- sqrt
    -- x = sqrt(x)

    -- -- test ---- if-only
    -- if x > 5 then
    --   x += i
    -- end

    -- -- test ---- if-else
    -- if x < 10 then
    --   x += i
    -- else
    --   x += i
    -- end

    -- -- test ---- if-elseif-else
    -- if x < 5 then
    --   x += i + i
    -- elseif x < 10 then
    --   x += -i
    -- else
    --   x += i
    -- end

    -- -- test ---- if, if, if
    -- if x < 5 then
    --   x += i + i
    -- end
    -- if x < 10 then
    --   x += -1
    -- end
    -- if x >= 10 then
    --   x += i
    -- end

    -- test ---- distance formula
    -- x += sqrt(x ^ 2 + i ^ i)

    -- test ---- distance formula squared
    -- x += x ^ 2 + i ^ i

    -- end of tests
  end
  return x -- i.e. does nothing
end

function _draw()
  cls()
  print('cpu  ' .. stat(1), 4, 4, 7)
  print('fps  ' .. stat(7), 4, 11, 7)
  print('time ' .. t(), 4, 18, 7)
end
