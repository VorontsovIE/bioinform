require_relative 'pm'

module Bioinform
  module MotifModel
    def self.acts_as_ppm?(ppm)
      ppm.is_a?(MotifModel::PPM) || ppm.is_a?(MotifModel::NamedModel) && acts_as_ppm?(ppm.model)
    end

    class PPM < PM
      def self.default_validator
        PPM::VALIDATOR
      end

      def self.probability_validator(eps: 1.0e-4)
        Validator.new{|matrix, alphabet|
          errors = []
          unless matrix.all?{|pos| pos.all?{|el| el >= 0 } }
            errors << "Elements of PPM should be non-negative."
          end

          warnings = []
          probability_sums = matrix.map{|pos| pos.inject(0.0, &:+) }
          max_discrepancy = probability_sums.map{|sum| (sum - 1.0).abs }.max
          unless max_discrepancy <= eps
            warnings << "PPM should sum up to 1, with discrepancy not greater than #{eps}."
          end

          ValidationResult.new(errors: errors, warnings: warnings)
        }
      end

      VALIDATOR = PM::VALIDATOR * PPM.probability_validator(eps: 1.0e-4).make_strict
    end
  end
end
