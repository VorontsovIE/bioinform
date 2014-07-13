require_relative '../formatters/raw_formatter'
require_relative '../errors'
require_relative '../alphabet'
require_relative 'named_model'

module Bioinform
  module MotifModel
    class PM
      attr_reader :matrix, :alphabet
      def initialize(matrix, options = {})
        @matrix = matrix
        @alphabet = options.fetch(:alphabet, NucleotideAlphabet)
        raise ValidationError.new('invalid matrix', validation_errors: validation_errors)  unless valid?
      end

      def validation_errors
        errors = []
        errors << "matrix should be an Array"  unless matrix.is_a? Array
        errors << "matrix shouldn't be empty"  unless matrix.size > 0
        errors << "each matrix position should be an Array"  unless matrix.all?{|pos| pos.is_a?(Array) }
        errors << "each matrix position should be of size compatible with alphabet (=#{alphabet.size})"  unless matrix.all?{|pos| pos.size == alphabet.size }
        errors << "each matrix element should be Numeric"  unless matrix.all?{|pos| pos.all?{|el| el.is_a?(Numeric) } }
        errors
      end

      def valid?
       validation_errors.empty?
      rescue
        false
      end

      private :valid?

      def length
        matrix.size
      end

      def to_s
        RawFormatter.new(with_name: false).format_string(self)
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
