pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_stack_defined_ = true

function stack_new()
  return { } -- just simple table
end

function stack_push(stack, e)
  add(stack, e)
end

function stack_pop(stack)
  if (#stack == 0) return nil
  local e = stack[#stack]
  stack[#stack] = nil -- or should this use del() ?
  return e
end

-->8
-- unit testing
x = stack_new()
stack_push(x, 1)
stack_push(x, 2)
stack_push(x, 3)
print(stack_pop(x))
print(stack_pop(x))
print(stack_pop(x))
print(stack_pop(x))
