require 'ostruct'
require_relative '../support'
require_relative '../parsers'
require_relative '../formatters'
require_relative '../formatters/pretty_matrix_formatter'

module Bioinform
  IndexByLetter = { 'A' => 0, 'C' => 1, 'G' => 2, 'T' => 3, A: 0, C: 1, G: 2, T: 3,
                    'a' => 0, 'c' => 1, 'g' => 2, 't' => 3, a: 0, c: 1, g: 2, t: 3}
  LetterByIndex = {0 => :A, 1 => :C, 2 => :G, 3 => :T}

  class PM
    attr_accessor :matrix, :parameters

    include Parameters
    make_parameters  :name, :background # , :tags

#    def mark(tag)
#      tags << tag
#    end

#    def tagged?(tag)
#      tags.any?{|t| (t.eql? tag) || (t.respond_to?(:name) && t.name && (t.name == tag)) }
#    end

    def self.choose_parser(input)
      # [TrivialParser, YAMLParser, Parser, StringParser, Bioinform::MatrixParser.new(has_name: false).wrapper, Bioinform::MatrixParser.new(has_name: true).wrapper, StringFantomParser, JasparParser, TrivialCollectionParser, YAMLCollectionParser].find do |parser|
      [TrivialParser.new, YAMLParser.new, Parser.new, StringParser.new, Bioinform::MatrixParser.new(has_name: false), Bioinform::MatrixParser.new(has_name: true), StringFantomParser.new, JasparParser.new, TrivialCollectionParser.new, YAMLCollectionParser.new].find do |parser|
        self.new(input, parser) rescue nil
      end
    end

    def self.split_on_motifs(input)
      parser = choose_parser(input)
      raise ParsingError, "No parser can parse given input"  unless parser
      CollectionParser.new(parser, input).split_on_motifs(self)
    end

    def initialize(input, parser = nil)
      @parameters = OpenStruct.new
      parser ||= self.class.choose_parser(input)
      raise 'No one parser can process input'  unless parser
      result = parser.parse(input)
      @matrix = result.matrix
      raise 'Non valid matrix' unless self.class.valid_matrix?(@matrix)
      self.name = result.name
#      self.tags = result.tags || []
      self.background = result.background || [1, 1, 1, 1]
    end

    def self.new_with_validation(input, parser = nil)
      obj = self.new(input, parser)
      raise 'matrix not valid'  unless obj.valid?
      obj
    end
    def ==(other)
      @matrix == other.matrix && background == other.background && name == other.name
    rescue
      false
    end

    def self.valid_matrix?(matrix, options = {})
      matrix.is_a?(Array) &&
      ! matrix.empty? &&
      matrix.all?{|pos| pos.is_a?(Array)} &&
      matrix.all?{|pos| pos.size == 4} &&
      matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric)}}
    rescue
      false
    end

    def validation_errors(options = {})
      errors = []
      if !matrix.is_a?(Array)
        errors << 'Matrix is not an array'
      elsif matrix.empty?
        errors << 'Matrix is not an array'
      elsif ! matrix.all?{|pos| pos.is_a?(Array)}
        errors << 'Some of matrix positions aren\'t represented as arrays'
      elsif ! matrix.all?{|pos| pos.size == 4}
        errors << 'Some of matrix positions have number of columns other than 4'
      elsif ! matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric)}}
        errors << 'Some of matrix elements aren\'t represented by numbers'
      end
      errors
    end

    def valid?(options = {})
      self.class.valid_matrix?(@matrix, options)
    end

    def each_position
      if block_given?
        matrix.each{|pos| yield pos}
      else
        self.to_enum(:each_position)
      end
    end

    def length
      @matrix.length
    end
    alias_method :size, :length

    def to_s(options = {}, formatter = RawFormatter)
      formatter.new(options).format_string(self)
    end

    def pretty_string(options = {})
      PrettyMatrixFormatter.new(options).format_string(self)
    end

    def consensus
      each_position.map{|pos|
        pos.each_with_index.max_by{|el, letter_index| el}
      }.map{|el, letter_index| letter_index}.map{|letter_index| %w{A C G T}[letter_index] }.join
    end


    def to_hash
      hsh = %w{A C G T}.each_with_index.collect_hash do |letter, letter_index|
        [ letter, @matrix.map{|pos| pos[letter_index]} ]
      end
      hsh.with_indifferent_access
    end

    def self.zero_column
      [0, 0, 0, 0]
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

    def discrete!(rate)
      @matrix.map!{|position| position.map{|element| (element * rate).ceil}}
      self
    end

    def vocabulary_volume
      background.inject(&:+) ** length
    end

    def probability
      sum = background.inject(0.0, &:+)
      background.map{|element| element.to_f / sum}
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
    def discrete(rate)
      dup.discrete!(rate)
    end
    def dup
      deep_dup
    end

    def as_pcm
      PCM.new(get_parameters.merge(matrix: matrix))
    end
    def as_ppm
      PPM.new(get_parameters.merge(matrix: matrix))
    end
    def as_pwm
      PWM.new(get_parameters.merge(matrix: matrix))
    end
  end
end
