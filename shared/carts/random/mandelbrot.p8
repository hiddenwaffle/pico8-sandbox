pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- iteration 1 makes a circle... does that mean anything?

-- based on stuff i learned from professor holly krieger's talk at:
-- https://www.youtube.com/watch?v=NGMRB4O922I
-- and how to multiply complex numbers:
-- https://www.mathsisfun.com/algebra/complex-number-multiply.html

-- pset(-64, -64, 11) -- upper left
-- pset(63, 63, 11)   -- lower right

function _init()
  camera(-64, -64)
  cls()
  for number_of_iterations = 1, 65 do
    rectfill(48 - 2, 0 - 2, 48 + 8, 0 + 6, 0)
    print(number_of_iterations, 48, 0, 7)
    for real = -2, 2, 0.03125 do
      for imaginary = -2, 2, 0.03125 do
        local color
        local unbounded, magnitude = _0_iteration_of_fc_gt_2(real, imaginary, number_of_iterations)
        if unbounded then
          color = determine_color(magnitude)
        else
          color = 0
        end
        local x = real * 32
        local y = imaginary * 32
        pset(x, y, color)
      end
    end
  end
end

function _0_iteration_of_fc_gt_2(c_real, c_imaginary, number_of_iterations)
  local z_real = 0       --\__ start with
  local z_imaginary = 0  --/   fc(0)
  for i = 1, number_of_iterations do
    z_real, z_imaginary = fc(z_real, z_imaginary, c_real, c_imaginary)
    local magnitude = magnitude_of(z_real, z_imaginary)
    if magnitude > 2 then
      return true, magnitude
    end
  end
  return false, 0
end

function fc(z_real, z_imaginary, c_real, c_imaginary)
  -- (a+bi)(c+di) = (ac−bd) + (ad+bc)i
  local nr, ni = (z_real * z_real - z_imaginary * z_imaginary),
                 (z_real * z_imaginary + z_imaginary * z_real)
  return nr + c_real, ni + c_imaginary
end

function magnitude_of(x, y)
  return sqrt(x ^ 2 + y ^ 2)
end

-- it would be between (2, 4] right?
function determine_color(magnitude)
  return ((magnitude - 2) / 2) * 15 + 1
end
