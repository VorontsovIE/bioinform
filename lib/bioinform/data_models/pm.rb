require 'active_support/core_ext/hash/indifferent_access'
require 'bioinform/support/collect_hash'
require 'bioinform/support/pmap'

class PM
  attr_reader :matrix
  attr_accessor :name
  
  def matrix=(matrix)
    raise ArgumentError, 'Matrix has invalid format:' unless self.class.valid? matrix
    @matrix = matrix
  end
  
  def self.valid?(matrix)
    matrix.is_a?(Array) && 
    matrix.all?{|pos| pos.is_a? Array} &&
    matrix.all?{|pos| pos.all?{|el| el.is_a? Numeric}} && 
    matrix.all?{|pos| pos.size == 4}
  end
  
  def size;  @matrix.size;   end
  alias_method :length, :size
  
  def to_s(with_name = true)
    matrix = @matrix.pmap("\t",&:join).join("\n")
    if with_name && @name 
      "#{@name}\n#{matrix}"
    else 
      matrix
    end
  end
  
  def pretty_string(with_name = true)
    header = %w{A C G T}.map{|el| el.rjust(4).ljust(7)}.join + "\n"
    matrix_rows = @matrix.map do |position|  
      position.map{|el| el.round(3).to_s.rjust(6)}.join(' ')
    end
    matrix = matrix_rows.join("\n")
    if with_name && @name
      @name + "\n" + header + matrix
    else
      header + matrix
    end
  end
  
  def to_hash
    hsh = %w{A C G T}.each_with_index.collect_hash do |letter, letter_index| 
      [ letter, @matrix.map{ |position| position[letter_index] } ]
    end
    hsh.with_indifferent_access
  end
  
end