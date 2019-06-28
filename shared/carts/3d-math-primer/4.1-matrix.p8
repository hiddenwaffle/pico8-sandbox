pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/matrix.p8
#include lib/vector2.p8
#include lib/vector3.p8

g = { }

function _init()
  cls()
  -- square matrix
  g.sm = matrix_type.from_table{
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }}
  -- square matrix's transpose
  g.smt = g.sm:transpose()
  -- back to original
  g.smtt = g.smt:transpose()
  -- 1x3 matrix
  g.m1x3 = matrix_type.from_table{
   { 1 },
   { 2 },
   { 3 }}
  -- 1x3 transposed to 3x1
  g.m1x3t = g.m1x3:transpose()
  -- 2x3 matrix
  -- g.m2x3 = matrix_type:new(2, 3)
  -- g.m2x3[1][1] = 1 ; g.m2x3[1][2] = 2 ; g.m2x3[1][3] = 3
  -- g.m2x3[2][1] = 4 ; g.m2x3[2][2] = 5 ; g.m2x3[2][3] = 6
  g.m2x3 = matrix_type.from_table{
    { 1, 2, 3 },
    { 4, 5, 6 }}
  -- 2x3 matrix scaled
  g.m2x3s = matrix_type:new(2, 3)
  g.m2x3:scale_to_ref(2, g.m2x3s)
  -- 3x2 matrix
  g.m3x2 = matrix_type.from_table{
    { 1, 2 },
    { 3, 4 },
    { 5, 6 }}
  -- product of 2x3 times 3x2 matrices
  g.m2x2 = g.m2x3:multiply(g.m3x2)
  -- vector2
  g.v2 = vector2_type:new(5, 6)
  g.m2x2_2 = matrix_type.from_table{
    { 1, 2 },
    { 3, 4 }}
  g.v2_2 = vector2_type:new()
  g.v2:transform_to_ref(g.m2x2_2, g.v2_2)
  -- vector3
  g.v3 = vector3_type:new(1, 2, 3)
  g.m3x3 = matrix_type.from_table{
    {  4,  5,  6 },
    {  7,  8,  9 },
    { 10, 11, 12 }}
  g.v3_2 = vector3_type:new()
  g.v3:transform_to_ref(g.m3x3, g.v3_2)
  -- visualization page starts at 1
  g.page = 3 -- todo: set back to 1
  g.done = false
end

function _update60()
  if (btnp(5)) g.page += 1
end

function _draw()
  cls(1)
  cursor(4, 4)
  color(6)
  if g.page == 1 then
    print('square matrix:')
    print(g.sm:to_str())
    print('square matrix transposed:')
    print(g.smt:to_str())
    print('square matrix transposed twice:')
    print(g.smtt:to_str())
    print('1x3 matrix:')
    print(g.m1x3:to_str())
    print('1x3 matrix transposed:')
    print(g.m1x3t:to_str())
  elseif g.page == 2 then
    print('2x3 matrix:')
    print(g.m2x3:to_str())
    print('2x3 matrix if scaled:')
    print(g.m2x3s:to_str())
    print('3x2 matrix:')
    print(g.m3x2:to_str())
    print('2x3 times 3x2:')
    print(g.m2x2:to_str())
  elseif g.page == 3 then
    print('vector2:')
    print(g.v2:to_str())
    print('matrix:')
    print(g.m2x2_2:to_str())
    print('product:')
    print(g.v2_2:to_str())
    print('')
    print('vector3:')
    print(g.v3:to_str())
    print('matrix:')
    print(g.m3x3:to_str())
    print('product:')
    print(g.v3_2:to_str())
  else
    g.done = true
  end
  if g.done then
    print('the end', 98, 120, 12)
  else
    print('❎ to turn page', 66, 120, 7)
  end
end
