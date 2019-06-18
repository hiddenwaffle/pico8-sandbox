pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- coding challenge #35.2
-- https://www.youtube.com/watch?v=goUlyp4rwiU

g = { }

function _init()
  g.vals = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
  g.done = false
end

function calculate()
  -- step 1
  local largest_i = -1
  for i = 1, #g.vals - 1 do
    if g.vals[i] < g.vals[i + 1] then
      largest_i = i
    end
  end
  if largest_i == -1 then
    return true -- done
  end
  -- step 2
  local largest_j = -1
  for j = 1, #g.vals do
    if g.vals[largest_i] < g.vals[j] then
      largest_j = j
    end
  end
  -- step 3
  swap(g.vals, largest_i, largest_j)
  -- step 4
  local len = #g.vals - largest_i - 1
  local end_array = splice(g.vals, largest_i + 1)
  reverse(end_array)
  concat(g.vals, end_array)
  return false
end

function _update60()
  if not g.done then
    g.done = calculate()
  end
end

function _draw()
  cls(1)
  local s = ''
  for i = 1, #g.vals do
    s = s .. tostring(g.vals[i])
  end
  print(s, 43, 48, 7)
end

-->8

function swap(a, i, j)
  local temp = a[i]
  a[i] = a[j]
  a[j] = temp
end

-- todo: maybe go into a library
function splice(a, start, count)
  count = count or (#a - start + 1)
  local subset = { }
  for i = start, start + count - 1 do
    add(subset, a[i])
  end
  for x in all(subset) do
    del(a, x)
  end
  return subset
end

-- todo: make more efficient
function reverse(a)
  local reversed = { }
  for i = #a, 1, -1 do
    add(reversed, a[i])
  end
  for i = 1, #reversed do
    a[i] = reversed[i]
  end
end

function concat(dest, src)
  for x in all(src) do
    add(dest, x)
  end
end

-- from https://www.lexaloffle.com/bbs/?pid=43636
-- converts anything to string, even nested tables
function tostring(any)
  if type(any)=="function" then
      return "function"
  end
  if any==nil then
      return "nil"
  end
  if type(any)=="string" then
      return any
  end
  if type(any)=="boolean" then
      if any then return "true" end
      return "false"
  end
  if type(any)=="table" then
      local str = "{ "
      for k,v in pairs(any) do
          str=str..tostring(k).."->"..tostring(v).." "
      end
      return str.."}"
  end
  if type(any)=="number" then
      return ""..any
  end
  return "unkown" -- should never show
end
