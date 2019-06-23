pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- based on the nature of code book by daniel shiffman

assert(lib_matrix_defined__)
lib_matrix_defined__ = true

neural_network_type = { }

function neural_network_type:new(num_i, num_h, num_o)
  local o = {
    input_nodes = num_i,
    hidden_nodes = num_h,
    output_nodes = num_o,
    weights_ih = matrix_type:new(num_h, num_i),
    weights_ho = matrix_type:new(num_o, num_h),
    bias_h = matrix_type:new(num_h, 1),
    bias_o = matrix_type:new(num_o, 1)
  }
  o.weights_ih:randomize()
  o.weights_ho:randomize()
  o.bias_h:randomize()
  o.bias_o:randomize()
  setmetatable(o, self)
  self.__index = self
  return o
end

function neural_network_type:feed_forward(input_array)
  -- generate the hidden's outputs
  local inputs = matrix_type.from_table(input_array)
  local hidden = matrix_type.mult(self.weights_ih, inputs)
  hidden:add(self.bias_h)
  hidden:map(neural_network_type.sigmoid)
  -- generate output's output
  local output = matrix_type.mult(self.weights_ho, hidden)
  output:add(self.bias_o)
  output:map(neural_network_type.sigmoid)
  -- done with calculations
  return output:totable()
end

function neural_network_type.sigmoid(x)
  return 1 / (1 + 2.71 ^ (-x))
end
