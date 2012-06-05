require 'bioinform/support'
require 'bioinform/data_models/parser'

class ArrayParser < PM::Parser
  def parse_core
    raise ArgumentError  unless input.is_a?(Array) && input.all?(&:is_a?.(Array)) && input.same_by?(&:length) && (input.size == 4 || input.sample.size == 4)
    if input.all?{|line| line.size == 4}
      {matrix: input}
    elsif input.size == 4
      {matrix: input.transpose}
    else
      raise ArgumentError
    end
  end
end