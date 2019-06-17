pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include lib/math.p8:0
#include lib/vector-procedural.p8:0

g = { }

function _init()
  poke(0x5f2d, 1)
  capture_mouse()
  g.cells = { }
  add(g.cells, cell_new())
  add(g.cells, cell_new())
end

function _update60()
  capture_mouse()
  if btnp(5) then
    local new_cells = { }
    local delete_cells = { }
    for cell in all(g.cells) do
      if cell_clicked(cell, g.mouse_x, g.mouse_y) then
        add(new_cells, cell_mitosis(cell))
        add(new_cells, cell_mitosis(cell))
        add(delete_cells, cell)
      end
    end
    for cell in all(delete_cells) do
      del(g.cells, cell)
    end
    for cell in all(new_cells) do
      add(g.cells, cell)
    end
  end
  for cell in all(g.cells) do
    cell_move(cell)
  end
end

function _draw()
  cls(1)
  for cell in all(g.cells) do
    cell_show(cell)
  end
  print('press x when mouse is over cell', 3, 4, 7)
  draw_mouse()
end

function capture_mouse()
  g.mouse_x = stat(32)
  g.mouse_y = stat(33)
end

function draw_mouse()
  local x = g.mouse_x
  local y = g.mouse_y
  for i = 1, 2 do
    pset(x, y + i, 5 + i)
    pset(x, y - i, 5 + i)
    pset(x - i, y, 5 + i)
    pset(x + i, y, 5 + i)
  end
end

-->8

function cell_new(pos, r, c)
  if pos then
    pos = vector_new(pos.x, pos.y)
  else
    pos = vector_new(flr(rnd(64)) + 32, flr((rnd(64))) + 32)
  end
  return {
    pos = pos,
    r = r or 20,
    c = c or flr(rnd(15)) + 1
  }
end

function cell_move(cell)
  local vel = vector_new()
  vector_random2d_to_ref(vel)
  vector_add_to_ref(cell.pos, vel, cell.pos)
end

function cell_show(cell)
  circfill(cell.pos.x, cell.pos.y, cell.r, cell.c)
  circ(cell.pos.x, cell.pos.y, cell.r, 0)
end

function cell_clicked(cell, x, y)
  local d = (cell.pos.x - x) ^ 2 + (cell.pos.y - y) ^ 2
  return d < cell.r ^ 2
end

function cell_mitosis(cell)
  return cell_new(cell.pos, cell.r / 2, cell.c)
end
