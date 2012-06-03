require 'bioinform/support'
require 'bioinform/data_models/parser'

class HashParser < PM::Parser
  def parse
    super
    case input
    when Hash
      { matrix: input.with_indifferent_access.values_at(:A,:C,:G,:T).transpose }
    when Array
      { matrix: input.map(&:values_at.(:A,:C,:G,:T)) }
    end
  end
  
  def can_parse?
    case input
    when Hash
      inp = input.with_indifferent_access
      inp.has_all_keys?(:A, :C, :G, :T) && inp.values_at(:A,:C,:G,:T).same_by?(&:length)
    when Array
      input.all?(&:is_a?.(Hash)) && input.all?{|position| position.size == 4}
    end
  rescue 
    false
  end
end