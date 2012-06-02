require 'active_support/core_ext/hash/indifferent_access'
require 'bioinform/support/collect_hash'
require 'bioinform/support/pmap'

class PM
  attr_reader :matrix
  attr_accessor :name
  def initialize(input = nil, parser = nil)
    return unless input
    if parser
      raise ArgumentError, 'Input cannot be parsed by specified parser' unless parser.new(input).can_parse?
    else
      parser = PM::Parser.subclasses.find{|parser_class| parser_class.new(input).can_parse? }
      raise ArgumentError, 'No one parser can parse specified input' unless parser
    end
    parse_result = parser.new(input).parse
    raise ArgumentError, 'Used parser result has no `matrix` key'  unless parse_result.has_key? :matrix
    raise ArgumentError, 'Parsing result is not a valid matrix'  unless self.class.valid?( parse_result[:matrix] )
    
    configure_from_hash(parse_result)
  end
  def configure_from_hash(parse_result)
    parse_result.each{|key, value|  send "#{key}=", value  if respond_to? "#{key}="  }
  end
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
  
  def length;  @matrix.size;   end
  alias_method :size, :length
  
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