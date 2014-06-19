require_relative 'pm'
require_relative '../alphabet'

module Bioinform
  module MotifModel
    class PWM < PM
      def score(word)
        raise Error, 'Word length should be the same as PWM length'  unless word.length == length
        length.times.map do |pos|
          matrix[pos][alphabet.index_by_letter(word[pos])]
        end.inject(0.0, &:+)
      end

      def discreted(rate, rounding_method: :ceil)
        discreted_matrix = matrix.map{|position| position.map{|element| (element * rate).send(rounding_method) } }
        self.class.new(discreted_matrix, alphabet: alphabet)
      end

      def zero_column
        [0.0] * alphabet.size
      end
      private :zero_column

      def left_augmented(n)
        raise Error, 'Augmenting with negative number of columns is impossible'  if n < 0
        augmented_matrix = Array.new(n, zero_column) + matrix
        self.class.new(augmented_matrix, alphabet: alphabet)
      end

      def right_augmented(n)
        raise Error, 'Augmenting with negative number of columns is impossible'  if n < 0
        augmented_matrix = matrix + Array.new(n, zero_column)
        self.class.new(augmented_matrix, alphabet: alphabet)
      end

      def to_IUPAC_PWM
        raise Error, 'this conversion is possible only for ACGT-nucleotide motifs'  unless alphabet.equal? NucleotideAlphabet
        iupac_matrix = matrix.map do |pwm_pos|
          IUPACAlphabet.each_letter.map do |letter|
            nucleotide_indices = IUPAC::NucleotideIndicesByIUPACLetter[letter]
            nucleotide_indices.inject(0.0){|sum, nucleotide_index| sum + pwm_pos[nucleotide_index] } / nucleotide_indices.size
          end
        end
        PWM.new(iupac_matrix, alphabet: IUPACAlphabet)
      end

    end
  end
end
