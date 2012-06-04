require 'bioinform/support'
require 'bioinform/data_models/parser'

class ArrayParser < PM::Parser
  def parse
    super
    if input.all?{|line| line.size == 4}
      {matrix: input}
    elsif input.size == 4
      {matrix: input.transpose}
    end
  end
  
  def can_parse?
    input.is_a?(Array) && input.all?(&:is_a?.(Array)) && input.same_by?(&:length) && (input.size == 4 || input.sample.size == 4)
  rescue
    false
  end
end