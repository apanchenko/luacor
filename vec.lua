--[[
    Vector of two elements. Extremely useful for 2D math.
]]--

local obj   = require 'src.lua-cor.obj'
local typ   = require 'src.lua-cor.typ'
local ass   = require 'src.lua-cor.ass'
local wrp   = require 'src.lua-cor.wrp'
local log = require('src.lua-cor.log').get('obj')

-- Define 2d vector type
local vec = obj:extend('vec')
vec.x = 0
vec.y = 0

-- Static copy vector value from one table to another
function vec.copy(from, to)
  to.x = from.x
  to.y = from.y
end

-- Static initialize table to screen center
function vec.center(obj)
  obj.x = display.contentWidth / 2
  obj.y = display.contentHeight / 2
end

-- Math operators
function vec.__add(l, r) return vec:new(l.x + r.x, l.y + r.y) end
function vec.__sub(l, r) return vec:new(l.x - r.x, l.y - r.y) end
function vec.__div(l, r) return vec:new(l.x / r.x, l.y / r.y) end
function vec.__mul(l, r) return vec:new(l.x * r.x, l.y * r.y) end
function vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-- Create a new vector
function vec:new(x, y)
  return obj.new(self, {x = x, y = y})
end

-- Create a random vector in range
function vec:random(min, max)
  return setmetatable({x = math.random(min.x, max.x), y = math.random(min.y, max.y)}, vec)
end

-- Create vector as a copy
function vec:from(obj)
  return vec(obj.x, obj.y)
end

-- Convert to log friendly string
function vec:__tostring()
  return '{'..self.x.. ",".. self.y..'}'
end

-- Compute square length
function vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end

-- Create new vector rounding x,y to closest integer values
function vec:round()
  return vec:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end

-- Copy x,y into obj
function vec:to(obj)
  obj.x = self.x
  obj.y = self.y
end

-- Create positive vector
function vec:abs()
  return vec:new(math.abs(self.x), math.abs(self.y))
end

-- Call fn for each integer in grid [0, vec-1]
function vec:iterate_grid_wrap_before(fn)
  ass.nat(self.x)
  ass.nat(self.y)
end
function vec:iterate_grid(fn)
  for x = 0, self.x - 1 do
    for y = 0, self.y - 1 do
      fn(vec(x, y))
    end
  end
end

-- Calculate 1D array index of this position in 2D grid
function vec:to_index(grid_size)
  ass.nat(self.x)
  ass.nat(self.y)
  ass.nat(grid_size.x)
  ass.nat(grid_size.y)
  ass.gt(grid_size.x, self.x)
  ass.gt(grid_size.y, self.y)
end
function vec:to_index(grid_size)
  return self.x * grid_size.y + self.y;
end

-- Constant zero vector
vec.zero = vec(0, 0)

-- Constant ones vector
vec.one = vec(1, 1)

-- Wrap vector functions
function vec:wrap()
  local is    = {'vec', typ.new_is(vec)}
  local ex    = {'exvec', typ.new_ex(vec)}


  wrp.fn(log.info, vec, 'copy',   {'from', typ.tab}, {'to', typ.tab})
  wrp.fn(log.info, vec, 'center', {'obj', typ.tab})

  wrp.fn(log.info, vec, 'new',    is, {'x', typ.num}, {'y', typ.num})
  wrp.fn(log.info, vec, 'random', is, {'min', vec}, {'max', vec})
  wrp.fn(log.info, vec, 'from',   is, {'obj', typ.tab})

  wrp.fn(log.info, vec, 'length2', ex)
  wrp.fn(log.info, vec, 'round',   ex)
  wrp.fn(log.info, vec, 'to',      ex, {'obj', typ.tab})
  wrp.fn(log.info, vec, 'abs',     ex)
  wrp.fn(log.info, vec, 'iterate_grid', ex, {'fn', typ.fun})
  wrp.fn(log.info, vec, 'to_index', ex, {'grid_size', vec})
end

return vec
