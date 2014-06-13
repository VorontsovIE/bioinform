require_relative '../formatters/raw_formatter'

module Bioinform
  class Error < ::StandardError
  end
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
        raise Error, 'invalid matrix'  unless valid?
      end

      def valid?
        matrix.size > 0 &&
        matrix.is_a?(Array) &&
        matrix.all?{|pos|
          pos.is_a?(Array) &&
          pos.size == alphabet.size &&
          pos.all?{|el| el.is_a?(Numeric) }
        }
      rescue
        false
      end

      private :valid?

      def length
        matrix.size
      end

      def to_s
        RawFormatter.new(self, with_name: false).to_s
      end

      def ==(other)
        self.class == other.class && matrix == other.matrix
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
      #   ConsensusFormatter.by_maximal_elements.consensus(self)
      # end

    end
  end
end
