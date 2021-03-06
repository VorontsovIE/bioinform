require_relative 'pm'

module Bioinform
  module MotifModel
    def self.acts_as_pwm?(pwm)
      pwm.is_a?(MotifModel::PWM) || pwm.is_a?(MotifModel::NamedModel) && acts_as_pwm?(pwm.model)
    end

    class PWM < PM
      VALIDATOR = PM::VALIDATOR

      def self.default_validator
        PWM::VALIDATOR
      end

      def score(word)
        raise Error, 'Word length should be the same as PWM length'  unless word.length == length
        length.times.map do |pos|
          matrix[pos][alphabet.index_by_letter(word[pos])]
        end.inject(0.0, &:+)
      end

      def discreted(rate, rounding_method: :ceil)
        discreted_matrix = matrix.map{|position|
          position.map{|element|
            (element * rate).send(rounding_method)
          }
        }
        self.class.new(discreted_matrix, alphabet: alphabet, validator: TRIVIAL_VALIDATOR)
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
    end
  end
end
