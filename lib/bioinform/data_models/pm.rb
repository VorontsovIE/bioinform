require 'ostruct'
require_relative '../support'
require_relative '../parsers'
require_relative '../formatters'
require_relative '../formatters/pretty_matrix_formatter'

require_relative '../data_models_2/pm'
require_relative '../data_models_2/named_model'

module Bioinform
  IndexByLetter = { 'A' => 0, 'C' => 1, 'G' => 2, 'T' => 3, A: 0, C: 1, G: 2, T: 3,
                    'a' => 0, 'c' => 1, 'g' => 2, 't' => 3, a: 0, c: 1, g: 2, t: 3}
  LetterByIndex = {0 => :A, 1 => :C, 2 => :G, 3 => :T}

  class PM
    attr_accessor :matrix, :name, :background

    def self.choose_collection_parser(input)
      [ TrivialCollectionParser.new, YAMLCollectionParser.new, StringParser.new ].find do |parser|
        self.new(input, parser) rescue nil
      end
    end

    def self.choose_parser(input)
      [ TrivialParser.new, YAMLParser.new, Parser.new, StringParser.new,
        Bioinform::MatrixParser.new(has_name: false), Bioinform::MatrixParser.new(has_name: true),
        StringFantomParser.new, JasparParser.new
      ].find do |parser|
        self.new(input, parser) rescue nil
      end
    end

    def self.split_on_motifs(input)
      parser = choose_collection_parser(input)
      raise ParsingError, "No parser can parse given input"  unless parser
      CollectionParser.new(parser, input).split_on_motifs(self)
    end

    def pm_inner
      MotifModel::NamedModel.new(MotifModel::PM.new(@matrix), @name)
    end

    def initialize(input, parser = nil)
      parser ||= self.class.choose_parser(input)
      raise 'No one parser can process input'  unless parser
      result = parser.parse(input)
      self.matrix = result.matrix
      self.name = result.name
      self.background = result.background || [1, 1, 1, 1]

      raise 'Non valid matrix' unless self.class.valid_matrix?(result.matrix)
    end

    def self.new_with_validation(input, parser = nil)
      obj = self.new(input, parser)
      raise 'matrix not valid'  unless obj.valid?
      obj
    end

    def ==(other)
      matrix == other.matrix && background == other.background && name == other.name
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
      self.class.valid_matrix?(matrix, options)
    end

    def each_position(&block)
      pm_inner.each_position(&block)
    end

    def length
      pm_inner.length
    end
    alias_method :size, :length

    def to_s(options = {}, formatter = RawFormatter)
      formatter.new(options).format_string(self)
    end

    def pretty_string(options = {})
      PrettyMatrixFormatter.new(options).format_string(self)
    end

    def consensus
      ConsensusFormatter.by_maximal_elements.format_string(pm_inner)
    end

    def to_hash
      hsh = %w{A C G T}.each_with_index.collect_hash do |letter, letter_index|
        [ letter, matrix.map{|pos| pos[letter_index]} ]
      end
      hsh.with_indifferent_access
    end

    def self.zero_column
      [0, 0, 0, 0]
    end

    def vocabulary_volume
      background.inject(&:+) ** length
    end

    def probability
      sum = background.inject(0.0, &:+)
      background.map{|element| element.to_f / sum}
    end

    def reverse_complement
      self.class.new( matrix: matrix.reverse.map(&:reverse), name: name, background: background )
    end
    def left_augment(n)
      self.class.new( matrix: Array.new(n){self.class.zero_column} + matrix, name: name, background: background )
    end
    def right_augment(n)
      self.class.new( matrix: matrix + Array.new(n){self.class.zero_column}, name: name, background: background )
    end
    def discrete(rate)
      self.class.new( matrix: matrix.map{|position| position.map{|element| (element * rate).ceil}}, name: name, background: background )
    end
  end
end
