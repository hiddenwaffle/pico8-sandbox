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
    bias_o = matrix_type:new(num_o, 1),
    learning_rate = 0.1
  }
  o.weights_ih:randomize()
  o.weights_ho:randomize()
  o.bias_h:randomize()
  o.bias_o:randomize()
  setmetatable(o, self)
  self.__index = self
  return o
end

function neural_network_type:feedforward(input_array)
  -- generate the hidden's outputs (see next method)
  local inputs = matrix_type.from_table(input_array)
  local hidden = matrix_type.mult(self.weights_ih, inputs)
  hidden:add(self.bias_h)
  hidden:map(neural_network_type.sigmoid)
  -- generate output's output (see next method)
  local outputs = matrix_type.mult(self.weights_ho, hidden)
  outputs:add(self.bias_o)
  outputs:map(neural_network_type.sigmoid)
  -- done with calculations
  return outputs:totable()
end

function neural_network_type:train(input_array, target_array)
  -- generate the hidden's outputs (see previous method)
  local inputs = matrix_type.from_table(input_array)
  local hidden = matrix_type.mult(self.weights_ih, inputs)
  hidden:add(self.bias_h)
  hidden:map(neural_network_type.sigmoid)
  -- generate output's output (see previous method)
  local outputs = matrix_type.mult(self.weights_ho, hidden)
  outputs:add(self.bias_o)
  outputs:map(neural_network_type.sigmoid)
  -- convert tables to matrix objects
  targets = matrix_type.from_table(target_array)
  -- calculate the error
  -- error = targets - outputs
  local output_errors = matrix_type.subtract(targets, outputs)
  -- calculate gradient
  local gradients = matrix_type.map_this(outputs, neural_network_type.dsigmoid)
  gradients:mult_by(output_errors)
  gradients:mult_by(self.learning_rate)
  -- calculate deltas
  local hidden_t = matrix_type.transpose(hidden)
  local weights_ho_deltas = matrix_type.mult(gradients, hidden_t)
  -- adjust weights by deltas
  self.weights_ho:add(weights_ho_deltas)
  -- adjust the bias by its deltas (which is just the gradients)
  self.bias_o:add(gradients)
  -- calculate the hidden layer errors
  local weights_ho_t = matrix_type.transpose(self.weights_ho)
  local hidden_errors = matrix_type.mult(weights_ho_t, output_errors)
  -- calculate the hidden gradient
  local hidden_gradient = matrix_type.map_this(hidden, neural_network_type.dsigmoid)
  hidden_gradient:mult_by(hidden_errors)
  hidden_gradient:mult_by(self.learning_rate)
  -- calculate input->hidden deltas
  local inputs_t = matrix_type.transpose(inputs)
  local weight_ih_deltas = matrix_type.mult(hidden_gradient, inputs_t)
  -- adjust the weights by deltas
  self.weights_ih:add(weight_ih_deltas)
  -- adjust the bias by its deltas (which is just the gradients)
  self.bias_h:add(hidden_gradient)
  -- debug:
  -- print('outputs:')
  -- print(outputs:tostr())
  -- print('targets:')
  -- print(targets:tostr())
  -- print('output_errors:')
  -- print(output_errors:tostr())
end

function neural_network_type.sigmoid(x)
  return 1 / (1 + 2.71 ^ (-x))
end

-- where y has already been sigmoided
function neural_network_type.dsigmoid(y)
  return y * (1 - y)
end
