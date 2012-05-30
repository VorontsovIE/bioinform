require 'bioinform/support/multiline_squish'
class PositionalMatrix
  module DefaultParser
    number_pat = '[+-]?\d+(\.\d+)?'
    row_pat = "(#{number_pat} )*#{number_pat}"
    name_pat = '>? ?(?<name>[\w.-]+)\n'
    matrix_pat = "(?<matrix>(#{row_pat}\n)*#{row_pat})"
    Pattern = /\A(#{name_pat})?#{matrix_pat}\z/
    def self.parse(input)
      input.multiline_squish.match(Pattern)
    end
  end
  
  module FantomParser
    number_pat = '[+-]?\d+(\.\d+)?'
    row_pat = "(#{number_pat} )*#{number_pat}"
    matrix_pat = "(?<matrix>(#{row_pat}\n)*#{row_pat})"
    Pattern = /\ANA (?<name>.+)\nA C G T\n#{matrix_pat}\z/
    def self.trim_first_position(input)
      inp = input.split("\n")
      ([inp[0]] + inp[1..-1].map{|x| x.split(' ')[1..4].join(' ') }).join("\n")
    end
    def self.parse(input)
      trim_first_position(input.multiline_squish).match(Pattern)
    end
  end
  
  
  
  attr_reader :name, :matrix
  def initialize(input,parser = DefaultParser)
    case input
    when String
      match = parser.parse(input)
      raise ArgumentError, 'Can\'t create positional matrix basing on such input' unless match
      @name = match[:name]
      @matrix = match[:matrix].split("\n").map{|row| row.split.map(&:to_f)}
    when Hash 
      inp = input.with_indifferent_access
      @matrix = [inp[:A],inp[:C], inp[:G], inp[:T]]
    when Array
      @matrix = input.map do |pos|
        case pos
        when Array then pos
        when Hash  then [pos[:A], pos[:C], pos[:G], pos[:T]]
        else raise ArgumentError, 'Unknown type of argument inner dimension'
        end
      end
    else
      raise ArgumentError, 'Unknown format of input: only Strings, Arrays and hashes\'re available'
    end
    raise ArgumentError, 'Input has the different number of columns in each row' unless @matrix.same?(&:size)
    raise ArgumentError unless @matrix.size == 4 || @matrix.first.size == 4
    @matrix = @matrix.transpose if @matrix.first.size != 4
  end
  
  def size
    @matrix.size
  end
  alias_method :length, :size
  
  def to_s(with_name = true)
    mat_str = @matrix.pmap("\t",&:join).join("\n")
    (with_name && @name) ? "#{@name}\n#{mat_str}" : mat_str
  end
  
  def pretty_string(with_name = true)
    header = "   A      C      G      T   \n"
    mat_str = @matrix.map{|position|  position.map{|el| el.round(3).to_s.rjust(6)}.join(' ') }.join("\n")
    (with_name && @name)  ?  @name + "\n" + header + mat_str  :  header + mat_str
  end
  
  def to_hash
    {A: @matrix.map{|pos| pos[0]}, C: @matrix.map{|pos| pos[1]}, G: @matrix.map{|pos| pos[2]}, T: @matrix.map{|pos| pos[3]}}.with_indifferent_access
  end
end