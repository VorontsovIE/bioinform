require_relative '../formatters/motif_formatter'
require_relative '../validator'
require_relative '../errors'
require_relative '../alphabet'
require_relative 'named_model'

module Bioinform
  module MotifModel
    class PM
      VALIDATOR = Validator.new{|matrix, alphabet|
        errors = []
        errors << "Matrix should be an Array."  unless matrix.is_a? Array
        errors << "Matrix shouldn't be empty."  unless matrix.size > 0
        errors << "Each matrix position should be an Array."  unless matrix.all?{|pos| pos.is_a?(Array) }
        errors << "Each matrix position should be of size compatible with alphabet (=#{alphabet.size})."  unless matrix.all?{|pos| pos.size == alphabet.size }
        errors << "Each matrix element should be Numeric."  unless matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric) } }
        ValidationResult.new(errors: errors)
      }

      attr_reader :matrix, :alphabet
      def initialize(matrix, alphabet: NucleotideAlphabet, validator: PM::VALIDATOR)
        validation_results = validator.validate_params(matrix, alphabet)
        unless validation_results.valid?
          raise ValidationError.new('Invalid matrix.', validation_errors: validation_results)
        end
        @matrix = matrix
        @alphabet = alphabet
      end

      DEFAULT_PARSER = MatrixParser.new
      def self.from_string(input, alphabet: NucleotideAlphabet, parser: DEFAULT_PARSER)
        info = parser.parse!(input)
        self.new(info[:matrix], alphabet: alphabet).named( info[:name] )
      end

      def self.from_file(filename, alphabet: NucleotideAlphabet, parser: DEFAULT_PARSER)
        info = parser.parse!(File.read(filename))
        name = (info[:name] && !info[:name].strip.empty?) ? info[:name] : File.basename(filename, File.extname(filename))
        self.new(info[:matrix], alphabet: alphabet).named( name )
      end

      def length
        matrix.size
      end

      def to_s
        MotifFormatter.new.format(self)
      end

      def ==(other)
        self.class == other.class && matrix == other.matrix && alphabet == other.alphabet
      end

      def each_position
        if block_given?
          matrix.each{|pos| yield pos}
        else
          self.to_enum(:each_position)
        end
      end

      def reversed
        self.class.new(matrix.reverse, alphabet: alphabet)
      end

      def complemented
        self.class.new(complement_matrix, alphabet: alphabet)
      end

      def reverse_complemented
        self.class.new(complement_matrix.reverse, alphabet: alphabet)
      end

      alias_method :revcomp, :reverse_complemented

      def complement_matrix
        matrix.map{|pos|
          alphabet.each_letter_index.map{|letter_index| pos[alphabet.complement_index(letter_index)]}
        }
      end
      private :complement_matrix

      # def consensus
      #   ConsensusFormatter.by_maximal_elements.format_string(self)
      # end

      def named(name)
        NamedModel.new(self, name)
      end

    end
  end
end
