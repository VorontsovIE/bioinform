require_relative '../formatters/raw_formatter'
require_relative '../error'
require_relative '../alphabet'

module Bioinform
  module MotifModel
    # VOCABULARY = ['A','C','G','T'].freeze
    # IndexByLetter = { 'A' => 0, 'C' => 1, 'G' => 2, 'T' => 3,
    #                   'a' => 0, 'c' => 1, 'g' => 2, 't' => 3,
    #                   A: 0, C: 1, G: 2, T: 3,
    #                   a: 0, c: 1, g: 2, t: 3}.freeze

    # CONSENSUS = {'A' => 'A', 'C' => 'C', 'G' => 'G', 'T' => 'T',
    #              'AC' => 'M', 'AG' => 'R', 'AT' => 'W', 'CG' => 'S', 'CT' => 'Y', 'GT' => 'K',
    #              'CGT' => 'B', 'AGT' => 'D', 'ACT' => 'H', 'ACG' => 'V',
    #              'ACGT' => 'N' }
    # LetterByIndex = {0 => :A, 1 => :C, 2 => :G, 3 => :T}.freeze

    class PM
      attr_reader :matrix, :alphabet
      def initialize(matrix, alphabet: NucleotideAlphabet)
        @matrix = matrix
        @alphabet = alphabet
        raise ValidationError.new('invalid matrix', validation_errors)  unless valid?
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

      def reverse
        self.class.new(matrix.reverse, alphabet: alphabet)
      end

      def complement
        self.class.new(complement_matrix, alphabet: alphabet)
      end

      def reverse_complement
        self.class.new(complement_matrix.reverse, alphabet: alphabet)
      end

      alias_method :revcomp, :reverse_complement

      def complement_matrix
        matrix.map{|pos|
          alphabet.each_letter_index.map{|letter_index| pos[alphabet.complement_index(letter_index)]}
        }
      end
      private :complement_matrix

      # def consensus
      #   ConsensusFormatter.by_maximal_elements.format_string(self)
      # end

    end
  end
end
