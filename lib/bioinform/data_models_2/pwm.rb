require_relative '../formatters/raw_formatter'
module Bioinform
  class Error < ::StandardError
  end
  module MotifModel
    VOCABULARY = ['A','C','G','T'].freeze
    IndexByLetter = { 'A' => 0, 'C' => 1, 'G' => 2, 'T' => 3, 
                      'a' => 0, 'c' => 1, 'g' => 2, 't' => 3,
                      A: 0, C: 1, G: 2, T: 3,
                      a: 0, c: 1, g: 2, t: 3}.freeze

    CONSENSUS = {'A' => 'A', 'C' => 'C', 'G' => 'G', 'T' => 'T',
                 'AC' => 'M', 'AG' => 'R', 'AT' => 'W', 'CG' => 'S', 'CT' => 'Y', 'GT' => 'K',
                 'CGT' => 'B', 'AGT' => 'D', 'ACT' => 'H', 'ACG' => 'V',
                 'ACGT' => 'N' }
    # LetterByIndex = {0 => :A, 1 => :C, 2 => :G, 3 => :T}.freeze

    class PWM
      ZERO_COLUMN = [0,0,0,0].freeze
      attr_reader :matrix, :name
      def initialize(matrix, name: nil)
        @matrix = matrix
        @name = name
        raise Error, 'invalid matrix'  unless valid?
      end

      def valid?
        matrix.size > 0 && 
        matrix.is_a?(Array) && 
        matrix.all?{|pos| 
          pos.is_a?(Array) && 
          pos.size == 4 && 
          pos.all?{|el| el.is_a?(Numeric) } 
        }
      rescue
        false
      end

      private :valid?

      def length
        matrix.size
      end

      # For scoring IUPAC-sequences and sequences with N-s, use special scoring model class (because it should consider background)
      def score(word)
        raise Error, 'Word length should be the same as PWM length'  unless word.length == length
        length.times.map do |pos|
          begin
            letter = word[pos]
            matrix[pos][IndexByLetter[letter]]
          rescue
            raise Error, 'Unknown nucleotide `#{letter}`'  unless IndexByLetter[letter]
          end
        end.inject(0.0, &:+)
      end

      def to_s
        RawFormatter.new(self).to_s
      end

      def ==(other)
        matrix == other.matrix && name == other.name
      end

      def each_position
        if block_given?
          matrix.each{|pos| yield pos}
        else
          self.to_enum(:each_position)
        end
      end

      def reverse
        reversed_matrix = matrix.reverse
        self.class.new(reversed_matrix, name: name)
      end
      
      def complement
        complement_matrix = matrix.map(&:reverse)
        self.class.new(complement_matrix, name: name)
      end

      def reverse_complement
        reverse_complemented_matrix = matrix.map(&:reverse).reverse
        self.class.new(reverse_complemented_matrix, name: name)
      end

      alias_method :revcomp, :reverse_complement
      
      def discreted(rate, rounding_method: :ceil)
        discreted_matrix = matrix.map{|position| position.map{|element| (element * rate).send(rounding_method) } }
        self.class.new(discreted_matrix, name: name)
      end

      def left_augment(n)
        augmented_matrix = Array.new(n) { ZERO_COLUMN } + matrix
        self.class.new(augmented_matrix, name: name)
      rescue
        raise Error, 'Augmenting with negative number of columns is impossible'
      end

      def right_augment(n)
        augmented_matrix = matrix + Array.new(n) { ZERO_COLUMN }
        self.class.new(augmented_matrix, name: name)
      rescue
        raise Error, 'Augmenting with negative number of columns is impossible'
      end

      def consensus
        matrix.map{|pos|
          max_el = pos.max
          nucleotide_indices = pos.each_with_index.find_all{|el, nucleotide_index| el == max_el }.map{|el, nucleotide_index| nucleotide_index }
          best_nucleotides = nucleotide_indices.map{|nucleotide_index| VOCABULARY[nucleotide_index]}.join
          CONSENSUS[best_nucleotides]
        }.join
      end

    end
  end
end
