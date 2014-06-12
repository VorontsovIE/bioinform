require_relative 'pm'

module Bioinform
  module MotifModel
    class PWM < PM

      # MOVE #score TO SEPARATE CLASS
      # For scoring IUPAC-sequences and sequences with N-s, use special scoring model class (because it should consider background)
      def score(word)
        raise Error, 'Word length should be the same as PWM length'  unless word.length == length
        length.times.map do |pos|
          begin
            letter = word[pos]
            matrix[pos][IndexByLetter[letter]]
          rescue => e
            if !IndexByLetter[letter]
              raise Error, 'Unknown nucleotide `#{letter}` at position #{pos}'
            else
              raise Error, e.message
            end
          end
        end.inject(0.0, &:+)
      end

      def discreted(rate, rounding_method: :ceil)
        discreted_matrix = matrix.map{|position| position.map{|element| (element * rate).send(rounding_method) } }
        self.class.new(discreted_matrix)
      end

      def left_augment(n)
        augmented_matrix = Array.new(n) { ZERO_COLUMN } + matrix
        self.class.new(augmented_matrix)
      rescue
        raise Error, 'Augmenting with negative number of columns is impossible'
      end

      def right_augment(n)
        augmented_matrix = matrix + Array.new(n) { ZERO_COLUMN }
        self.class.new(augmented_matrix)
      rescue
        raise Error, 'Augmenting with negative number of columns is impossible'
      end
    end
  end
end
