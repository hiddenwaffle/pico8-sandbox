pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  g_width = 16
  g_height = 16
  g_size = 8
  g_cells = { }
  g_offsets = {
    { ['x'] = -1, ['y'] = -1 },
    { ['x'] =  0, ['y'] = -1 },
    { ['x'] =  1, ['y'] = -1 },
    { ['x'] = -1, ['y'] =  0 },
    { ['x'] =  1, ['y'] =  0 },
    { ['x'] = -1, ['y'] =  1 },
    { ['x'] =  0, ['y'] =  1 },
    { ['x'] =  1, ['y'] =  1 }
  }
  g_t = 0
  for i = 0, g_width * g_height - 1 do
    g_cells[i] = {
      ['current']  = rnd_tf(),
      ['previous'] = false
    }
  end
end

function rnd_tf()
  local x = flr(rnd(2))
  if (x == 1) return true
  return false
end

function convert_index_to_xy(index)
  return index % g_width, flr(index / g_width)
end

function convert_xy_to_index(x, y)
  return x + y * g_width
end

function in_bounds(x, y)
  if x >= 0 and x < g_width and y >= 0 and y < g_height then
    return true
  end
  return false
end

function _update()
  g_t += 1
  if (g_t > 3) then
    next_gen()
    g_t = 0
  end
  if btnp(5) then
    _init()
  end
end

function next_gen()
  for index, cell in pairs(g_cells) do
    cell['previous'] = cell['current']
  end
  for index, cell in pairs(g_cells) do
    cell['current'] = calculate_new_state(index)
  end
end

function calculate_new_state(index)
  local count = count_neighbors(index)
  local alive = g_cells[index]['previous']
  if alive and (count == 2 or count == 3) then
    return true
  elseif count == 3 then
    return true
  end
  return false
end

function count_neighbors(index)
  local x, y = convert_index_to_xy(index, g_width)
  local count = 0
  for offset in all(g_offsets) do
    local neighbor_x = x + offset['x']
    local neighbor_y = y + offset['y']
    if (in_bounds(neighbor_x, neighbor_y)) then
      local neighbor_index = convert_xy_to_index(neighbor_x, neighbor_y)
      local neighbor = g_cells[neighbor_index]
      if (neighbor['previous']) count += 1
    end
  end
  return count
end

function _draw()
  cls()
  for index, cell in pairs(g_cells) do
    if cell['current'] then
      local x, y = convert_index_to_xy(index)
      rectfill(x * g_size, y * g_size, (x + 1) * g_size, (y + 1) * g_size, 15)
    end
  end
  print('press ❎ to restart', 30, 122, 5)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
