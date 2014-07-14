require_relative '../alphabet'

module Bioinform
  module ConversionAlgorithms
    class PWM2IupacPWMConverter
      attr_reader :iupac_alphabet
      def initialize(options = {})
        @iupac_alphabet = options.fetch(:alphabet, NucleotideAlphabetWithN)
      end
      def convert(pwm)
        raise Error, "Can convert only PWMs"  unless MotifModel.acts_as_pwm?(pwm)
        raise Error, 'this conversion is possible only for ACGT-nucleotide motifs'  unless pwm.alphabet == NucleotideAlphabet
        iupac_matrix = pwm.each_position.map do |pos|
          @iupac_alphabet.each_letter.map do |letter|
            nucleotide_indices = IUPAC::NucleotideIndicesByIUPACLetter[letter]
            nucleotide_indices.inject(0.0){|sum, nucleotide_index| sum + pos[nucleotide_index] } / nucleotide_indices.size
          end
        end
        MotifModel::PWM.new(iupac_matrix, alphabet: @iupac_alphabet)
      end
    end
  end
end
