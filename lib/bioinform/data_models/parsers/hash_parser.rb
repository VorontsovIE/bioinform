require 'bioinform/support'
require 'bioinform/data_models/parser'

class HashParser < PM::Parser
  def parse_core
    case input
    when Hash
      raise ArgumentError  unless input.with_indifferent_access.has_all_keys?(:A, :C, :G, :T) && input.with_indifferent_access.values_at(:A,:C,:G,:T).same_by?(&:length)
      { matrix: input.with_indifferent_access.values_at(:A,:C,:G,:T).transpose }
    when Array
      raise ArgumentError  unless input.all?(&:is_a?.(Hash)) && input.all?{|position| position.size == 4}
      { matrix: input.map(&:with_indifferent_access).map(&:values_at.(:A,:C,:G,:T)) }
    else
      raise ArgumentError
    end
  end

end