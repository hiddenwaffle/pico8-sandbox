pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- different from lectures due to lua vs java differences
-- mostly just a playground for these references:
-- https://www.lua.org/pil/contents.html#13
-- https://www.lua.org/pil/contents.html#16

function _init()
  cls()
  _13()
  _13_1()
  _13_2()
  _13_3()
  _13_4_1()
  _13_4_2()
  _13_4_3()
  _13_4_4()
  _13_4_5()
  _16()
  _16_1()
  _16_2()
  -- <skipping the rest of ch 16>
end

function _13()
  print(' -- 13 metatables, metamethods')
  local t = {}
  print(getmetatable(t))
  local t1 = {}
  setmetatable(t, t1)
  assert(getmetatable(t) == t1)
end

function _13_1()
  print(' -- 13.1 arithmetic metamethods')
  set_type = { } -- <-------------------- global for following functions
  set_type.mt = { }
  function set_type.new(t)
    local set = { }
    setmetatable(set, set_type.mt)
    for i = 1, #t do -- no ipairs() in pico-8...
      local l = t[i]
      set[l] = true
    end
    return set
  end
  function set_type.union(a, b)
    assert(getmetatable(a) == set_type.mt and getmetatable(b) == set_type.mt) -- no error() in pico-8
    local res = set_type.new{}
    for k in pairs(a) do
      res[k] = true
    end
    for k in pairs(b) do
      res[k] = true
    end
    return res
  end
  function set_type.intersection(a, b)
    local res = set_type.new{}
    for k in pairs(a) do
      res[k] = b[k]
    end
    return res
  end
  function set_type.tostring(set)
    local s = '{'
    local sep = ''
    for e in pairs(set) do
      s = s .. sep .. e
      sep = ', '
    end
    return s .. '}'
  end
  function set_type.print(s)
    print(set_type.tostring(s))
  end
  local s1 = set_type.new{10, 20, 30, 50}
  local s2 = set_type.new{30, 1}
  print(getmetatable(s1))
  print(getmetatable(s2))
  set_type.mt.__add = set_type.union
  local s3 = s1 + s2
  set_type.print(s3) --> {1, 10, 20, 30, 50} in any order
  set_type.mt.__mul = set_type.intersection
  set_type.print((s1 + s2) * s1) --> {10, 20, 30, 50} in any order
  -- see also: __sub, __div, __unm, __pow, __concat

  -- the below lines will error
  -- local s = set_type.new{1, 2, 3}
  -- s = s + 8
end

function _13_2()
  print(' -- 13.2 relational metamethods')
  set_type.mt.__le = function (a, b) -- set containment
    for k in pairs(a) do
      if (not b[k]) return false
    end
    return true
  end
  set_type.mt.__lt = function (a, b)
    return a <= b and not (b <= a)
  end
  set_type.mt.__eq = function (a, b)
    return a <= b and b <= a
  end
  local s1 = set_type.new{2, 4}
  local s2 = set_type.new{4, 10, 2}
  print(s1 <= s2)
  print(s1 < s2)
  print(s1 >= s1)
  print(s1 > s1)
  print(s1 == s2 * s1)
end

function _13_3()
  print(' -- 13.3 library-defined')
  -- note: pico-8 print() does not seem to use __tostring()
  --       skipping the example
  set_type.mt.__metatable = 'anything can go here'
  s1 = set_type.new{}
  print(getmetatable(s1))
  -- below line will cause a runtime error
  -- setmetatable(s1, {})
end

function _13_4_1()
  print(' -- 13.4.1 __index')
  local window_type = { }
  window_type.prototype = {
    x = 0,
    y = 0,
    width = 100,
    height = 100
  }
  window_type.mt = { }
  function window_type.new(o)
    setmetatable(o, window_type.mt)
    return o
  end
  -- long way, more flexible:
  -- window_type.mt.__index = function (table, key)
  --   return window_type.prototype[key]
  -- end
  -- short way, more concise:
  window_type.mt.__index = window_type.prototype
  local w = window_type.new{x = 10, y = 20}
  print(w.width) --> 100
end

function _13_4_2()
  print(' -- 13.4.2 __newindex')
  local magic = { }
  magic.mt = { }
  magic.mt.__newindex = function (t, k, v)
    rawset(t, k, v * 2)
  end
  setmetatable(magic, magic.mt)
  magic['test'] = 123
  print(magic['test']) --> 246
end

function _13_4_3()
  print(' -- 13.4.3 default values')
  function set_default(t, d)
    local mt = {__index = function () return d end}
    setmetatable(t, mt)
  end
  tab = {x = 10, y = 20}
  print(tab.z)
  set_default(tab, 1337)
  print(tab.z)
end

function _13_4_4()
  print(' -- 13.4.4 tracking access')
  local t = {}
  local _t = t
  t = {}
  local mt = {
    __index = function (t, k)
      print('*access to element ' .. tostring(k))
      return _t[k]
    end,
    __newindex = function (t, k, v)
      print(
        '*update of element ' .. tostring(k) ..
        ' to ' .. tostring(v))
      _t[k] = v
    end
  }
  setmetatable(t, mt)
  t[2] = 'hello'
  print(t[2])
  ---
  --- more general solution:
  local index = {}
  local mt = {
    __index = function (t, k)
      print('.access to element ' .. tostring(k))
      return t[index][k]
    end,
    __newindex = function (t, k, v)
      print('.update of element ' .. tostring(k) ..
            ' to ' .. tostring(v))
      t[index][k] = v
    end
  }
  function track(t)
    local proxy = {}
    proxy[index] = t
    setmetatable(proxy, mt)
    return proxy
  end
  t = {}
  proxy = track(t)
  proxy[1] = 'test1'
  proxy[1] = 'test2'
  print(proxy[1])
end

function _13_4_5()
  print(' -- 13.4.5 read-only tables')
  function read_only(t)
    local proxy = {}
    local mt = {
      __index = t,
      __newindex = function (t, k, v)
        assert(false) -- attempt to update a read-only table
      end
    }
    setmetatable(proxy, mt)
    return proxy
  end
  days = read_only{'s', 'm', 't', 'w', 'th', 'f', 'sa', 'su'}
  print(days[1])
  -- next line will error:
  -- days[2] = 'cannot do this'
end

-->8

function _16()
  print(' -- 16 oop')
  local account = {
    balance = 0,
    withdraw = function (self, v)
      self.balance -= v
    end
  }
  function account:deposit(v)
    self.balance += v
  end
  account.deposit(account, 200)
  account:withdraw(100)
  print(account.balance)
end

function _16_1()
  print(' -- 16.1 classes')
  local account = { balance = 0 }
  function account:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end
  function account:deposit(v)
    self.balance += v
  end
  local a = account:new{balance = 0}
  a:deposit(102)
  print(a.balance)
end

function _16_2()
  print(' -- 16.2 inheritance')
  account = { balance = 0 }
  function account:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
  end
  function account:deposit(v)
    self.balance += v
  end
  function account:withdraw(v)
    if v > self.balance then
      assert(false) -- insufficient funds
    end
    self.balance -= v
  end
  special_account = account:new()
  s = special_account:new{ limit = 1000 }
  s:deposit(123)
  print(s.balance)
  function special_account:withdraw(v)
    if v - self.balance >= self:get_limit() then
      assert(false) -- insufficient funds
    end
    self.balance -= v
  end
  function special_account:get_limit()
    return self.limit or 0
  end
  -- next line would error
  -- special_account:withdraw(10)
end

-->8

-- https://www.lexaloffle.com/bbs/?pid=43636
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
