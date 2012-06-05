require 'bioinform/support'

class PM
  attr_reader :matrix
  attr_accessor :name
  
  def initialize(input = nil, parser = nil)
    @background = [1, 1, 1, 1]
    return unless input
    if parser
      raise ArgumentError, 'Input cannot be parsed by specified parser' unless parser.new(input).can_parse?
    else
      parser = PM::Parser.subclasses.find{|parser_class| parser_class.new(input).can_parse? }
      raise ArgumentError, 'No one parser can parse specified input' unless parser
    end
    parse_result = parser.new(input).parse
    raise ArgumentError, 'Used parser result has no `matrix` key'  unless parse_result.has_key? :matrix
    
    configure_from_hash(parse_result)
  end
  
  def valid?
    @matrix.is_a?(Array) && 
    @matrix.all?(&:is_a?.(Array)) &&
    @matrix.all?(&:all?.(&:is_a?.(Numeric))) && 
    @matrix.all?{|pos| pos.size == 4}
  end
  
  def configure_from_hash(parse_result)
    parse_result.each{|key, value|  send("#{key}=", value)  if respond_to? "#{key}="  }
  end
  
  def matrix=(new_matrix)
    old_matrix, @matrix = matrix, new_matrix
    raise ArgumentError, 'Matrix has invalid format:' unless valid?
  rescue
    @matrix = old_matrix
    raise
  end
  
  def length;  
    @matrix.length;
  end
  alias_method :size, :length
  
  def to_s(with_name = true)
    matrix = @matrix.map(&:join.("\t")).join("\n")
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
      [ letter, @matrix.map(&:at.(letter_index)) ]
    end
    hsh.with_indifferent_access
  end
  
  # pm.background - returns a @background attribute
  # pm.background(new_background) - sets an attribute and returns pm itself
  # if more than one argument passed - raises an exception
  def background(*args)
    case args.size
    when 0 then @background
    when 1 then @background = args[0]; self
    else raise ArgumentError, '#background method can get 0 or 1 argument'
    end
  end
  
  def self.zero_column
    [0.0, 0.0, 0.0, 0.0]
  end

  def reverse_complement!
    @matrix.reverse!.map!(&:reverse!)
    self
  end
  def left_augment!(n)
    n.times{ @matrix.unshift(self.class.zero_column) }
    self
  end
  def right_augment!(n)
    n.times{ @matrix.push(self.class.zero_column) }
    self
  end
  def shift_to_zero! # make worst score == 0 by shifting scores of each column
    @matrix.map!{|position| min = position.min; position.map{|element| element - min}}
    self
  end
  def discrete!(rate)
    @matrix.map!{|position| position.map{|element| (element * rate).ceil}}
    self
  end

  def background_sum
    @background.inject(0.0, &:+)
  end

  def vocabulary_volume
    background_sum ** length
  end

  #def split(first_chunk_length)
  #  [@matrix.first(first_chunk_length), matrix.last(length - first_chunk_length)]
  #end
  #def permute_columns(permutation_index)
  #  @matrix.values_at(permutation_index)permutation_index.map{|col| matrix[col]}
  #end

  def best_score
    @matrix.inject(0.0){|sum, col| sum + col.max}
  end
  def worst_score
    @matrix.inject(0.0){|sum, col| sum + col.min}
  end
  
  # best score of suffix s[i..l]
  def best_suffix
    Array.new(length + 1) {|i| @matrix[i...length].map(&:max).inject(0.0, &:+) }
  end
  
  def worst_suffix
    Array.new(length + 1) {|i| @matrix[i...length].map(&:min).inject(0.0, &:+) }
  end
  
  def reverse_complement
    dup.reverse_complement!
  end
  def left_augment(n)
    dup.left_augment!(n)
  end
  def right_augment(n)
    dup.right_augment!(n)
  end
  def shift_to_zero
    dup.shift_to_zero!
  end
  def discrete(rate)
    dup.discrete!(rate)
  end
  
end