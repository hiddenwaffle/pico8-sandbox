pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  os2d_noise(rnd(0, 32767)) -- todo: does not act random?
  flowfield = make_flowfield(4)
  vehicles = { }
  for i = 1, 60 do
    local vehicle = make_vehicle(
      make_vector(rnd(128), rnd(128)),
      rnd(1) + 1,
      rnd(0.025) + 0.025)
    add(vehicles, vehicle)
  end
end

function _update60()
  for v in all(vehicles) do
    v:follow(flowfield)
    v:update()
  end
end

function _draw()
  cls()
  flowfield.display()
  for v in all(vehicles) do
    v:display()
  end
end

-->8

function make_vehicle(l, ms, mf)
  local color = 0
  while color != 0 do
    color = flr(rnd(16))
  end
  return {
    color = flr(rnd(16)),
    position = l:get(),
    r = 3,
    maxspeed = ms, -- 1,
    maxforce = mf, -- 0.025,
    acceleration = make_vector(0, 0),
    velocity = make_vector(0, 0),
    follow = function (self, flow)
      local desired = flow:lookup(self.position)
      desired:mult(self.maxspeed)
      local steer = vector_sub(desired, self.velocity)
      steer:limit(self.maxforce)
      self:apply_force(steer)
    end,
    apply_force = function (self, force)
      self.acceleration:add(force)
    end,
    update = function (self)
      self.velocity:add(self.acceleration)
      self.velocity:limit(self.maxspeed)
      self.position:add(self.velocity)
      self.acceleration:mult(0)
      self:borders()
    end,
    display = function (self)
      -- todo: draw a triangle using self.r
      rect(self.position.x - 1, self.position.y -1,
           self.position.x + 1, self.position.y + 1,
           self.color)
    end,
    borders = function (self)
      if (self.position.x < -self.r) self.position.x = 128 + self.r
      if (self.position.y < -self.r) self.position.y = 128 + self.r
      if (self.position.x > 128 + self.r) self.position.x = - self.r
      if (self.position.y > 128 + self.r) self.position.y = - self.r
    end
  }
end

-->8

function vector_div(v, n)
  return make_vector(v.x / n, v.y / n)
end

function vector_sub(a, b)
  return make_vector(a.x - b.x, a.y - b.y)
end

function make_vector(x, y)
  return {
    x = x,
    y = y,
    add = function (self, other)
      self.x += other.x
      self.y += other.y
    end,
    sub = function (self, other)
      self.x -= other.x
      self.y -= other.y
    end,
    mult = function (self, amt)
      self.x *= amt
      self.y *= amt
    end,
    mag = function (self)
      return sqrt(self:mag_sq())
    end,
    mag_sq = function (self)
      return self.x ^ 2 + self.y ^ 2
    end,
    normalize = function (self)
      local m = self:mag()
      if (m == 0) m = 0.01 -- bandaid
      self.x /= m
      self.y /= m
    end,
    set_mag = function (self, amt)
      self:normalize()
      self:mult(amt)
    end,
    limit = function (self, amt)
      if (self:mag() > amt) then
        self:normalize()
        self:mult(amt)
      end
    end,
    get = function (self)
      return make_vector(self.x, self.y)
    end
  }
end

-->8

function make_flowfield(r)
  local o = {
    resolution = r,
    cols = 128 / r,
    rows = 128 / r,
    field = { },
    init = function (self)
      local xoff = 0
      for i = 0, self.cols do
        local yoff = 0
        self.field[i] = { }
        for j = 0, self.rows do
          local theta = os2d_eval(xoff, yoff) -- perlin
          -- local theta = rnd(0.5) + 0.66 -- move mostly down right
          self.field[i][j] = make_vector(cos(theta), sin(theta))
          yoff += 0.1
        end
        xoff += 0.1
      end
    end,
    display = function (self)
      -- todo
    end,
    lookup = function (self, lookup)
      local column = flr(mid(lookup.x / self.resolution, 1, self.cols))
      local row    = flr(mid(lookup.y / self.resolution, 1, self.rows))
      return self.field[column][row]:get()
    end
  }
  o:init()
  return o
end

-->8

-- credits ------------------------------------
-- the rest of the lua section is from:
-- https://www.lexaloffle.com/bbs/?pid=52128
-- written by a user named felice
-----------------------------------------------

-- opensimplex noise

-- adapted from public-domain
-- code found here:
-- https://gist.github.com/kdotjpg/b1270127455a94ac5d19

--------------------------------

-- opensimplex noise in java.
-- by kurt spencer
--
-- v1.1 (october 5, 2014)
-- - added 2d and 4d implementations.
-- - proper gradient sets for all dimensions, from a
--   dimensionally-generalizable scheme with an actual
--   rhyme and reason behind it.
-- - removed default permutation array in favor of
--   default seed.
-- - changed seed-based constructor to be independent
--   of any particular randomization library, so results
--   will be the same when ported to other languages.

-- (1/sqrt(2+1)-1)/2
local _os2d_str=-0.211324865405187
-- (  sqrt(2+1)-1)/2
local _os2d_squ= 0.366025403784439

-- cache some constant invariant
-- expressions that were
-- probably getting folded by
-- kurt's compiler, but not in
-- the pico-8 lua interpreter.
local _os2d_squ_pl1=_os2d_squ+1
local _os2d_squ_tm2=_os2d_squ*2
local _os2d_squ_tm2_pl1=_os2d_squ_tm2+1
local _os2d_squ_tm2_pl2=_os2d_squ_tm2+2

local _os2d_nrm=47

local _os2d_prm={}

-- gradients for 2d. they
-- approximate the directions to
-- the vertices of an octagon
-- from the center
local _os2d_grd =
{[0]=
     5, 2,  2, 5,
    -5, 2, -2, 5,
     5,-2,  2,-5,
    -5,-2, -2,-5,
}

-- initializes generator using a
-- permutation array generated
-- from a random seed.
-- note: generates a proper
-- permutation, rather than
-- performing n pair swaps on a
-- base array.
function os2d_noise(seed)
    local src={}
    for i=0,255 do
        src[i]=i
        _os2d_prm[i]=0
    end
    srand(seed)
    for i=255,0,-1 do
        local r=flr(rnd(i+1))
        _os2d_prm[i]=src[r]
        src[r]=src[i]
    end
end

-- 2d opensimplex noise.
function os2d_eval(x,y)
    -- put input coords on grid
    local sto=(x+y)*_os2d_str
    local xs=x+sto
    local ys=y+sto

    -- flr to get grid
    -- coordinates of rhombus
    -- (stretched square) super-
    -- cell origin.
    local xsb=flr(xs)
    local ysb=flr(ys)

    -- skew out to get actual
    -- coords of rhombus origin.
    -- we'll need these later.
    local sqo=(xsb+ysb)*_os2d_squ
    local xb=xsb+sqo
    local yb=ysb+sqo

    -- compute grid coords rel.
    -- to rhombus origin.
    local xins=xs-xsb
    local yins=ys-ysb

    -- sum those together to get
    -- a value that determines
    -- which region we're in.
    local insum=xins+yins

    -- positions relative to
    -- origin point.
    local dx0=x-xb
    local dy0=y-yb

    -- we'll be defining these
    -- inside the next block and
    -- using them afterwards.
    local dx_ext,dy_ext,xsv_ext,ysv_ext

    local val=0

    -- contribution (1,0)
    local dx1=dx0-_os2d_squ_pl1
    local dy1=dy0-_os2d_squ
    local at1=2-dx1*dx1-dy1*dy1
    if at1>0 then
        at1*=at1
        local i=band(_os2d_prm[(_os2d_prm[(xsb+1)%256]+ysb)%256],0x0e)
        val+=at1*at1*(_os2d_grd[i]*dx1+_os2d_grd[i+1]*dy1)
    end

    -- contribution (0,1)
    local dx2=dx0-_os2d_squ
    local dy2=dy0-_os2d_squ_pl1
    local at2=2-dx2*dx2-dy2*dy2
    if at2>0 then
        at2*=at2
        local i=band(_os2d_prm[(_os2d_prm[xsb%256]+ysb+1)%256],0x0e)
        val+=at2*at2*(_os2d_grd[i]*dx2+_os2d_grd[i+1]*dy2)
    end

    if insum<=1 then
        -- we're inside the triangle
        -- (2-simplex) at (0,0)
        local zins=1-insum
        if zins>xins or zins>yins then
            -- (0,0) is one of the
            -- closest two triangular
            -- vertices
            if xins>yins then
                xsv_ext=xsb+1
                ysv_ext=ysb-1
                dx_ext=dx0-1
                dy_ext=dy0+1
            else
                xsv_ext=xsb-1
                ysv_ext=ysb+1
                dx_ext=dx0+1
                dy_ext=dy0-1
            end
        else
            -- (1,0) and (0,1) are the
            -- closest two vertices.
            xsv_ext=xsb+1
            ysv_ext=ysb+1
            dx_ext=dx0-_os2d_squ_tm2_pl1
            dy_ext=dy0-_os2d_squ_tm2_pl1
        end
    else  //we're inside the triangle (2-simplex) at (1,1)
        local zins = 2-insum
        if zins<xins or zins<yins then
            -- (0,0) is one of the
            -- closest two triangular
            -- vertices
            if xins>yins then
                xsv_ext=xsb+2
                ysv_ext=ysb
                dx_ext=dx0-_os2d_squ_tm2_pl2
                dy_ext=dy0-_os2d_squ_tm2
            else
                xsv_ext=xsb
                ysv_ext=ysb+2
                dx_ext=dx0-_os2d_squ_tm2
                dy_ext=dy0-_os2d_squ_tm2_pl2
            end
        else
            -- (1,0) and (0,1) are the
            -- closest two vertices.
            dx_ext=dx0
            dy_ext=dy0
            xsv_ext=xsb
            ysv_ext=ysb
        end
        xsb+=1
        ysb+=1
        dx0=dx0-_os2d_squ_tm2_pl1
        dy0=dy0-_os2d_squ_tm2_pl1
    end

    -- contribution (0,0) or (1,1)
    local at0=2-dx0*dx0-dy0*dy0
    if at0>0 then
        at0*=at0
        local i=band(_os2d_prm[(_os2d_prm[xsb%256]+ysb)%256],0x0e)
        val+=at0*at0*(_os2d_grd[i]*dx0+_os2d_grd[i+1]*dy0)
    end

    -- extra vertex
    local atx=2-dx_ext*dx_ext-dy_ext*dy_ext
    if atx>0 then
        atx*=atx
        local i=band(_os2d_prm[(_os2d_prm[xsv_ext%256]+ysv_ext)%256],0x0e)
        val+=atx*atx*(_os2d_grd[i]*dx_ext+_os2d_grd[i+1]*dy_ext)
    end
    return val/_os2d_nrm
end
