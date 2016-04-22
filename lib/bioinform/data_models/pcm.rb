require_relative 'pm'

module Bioinform
  module MotifModel
    def self.acts_as_pcm?(pcm)
      pcm.is_a?(MotifModel::PCM) || pcm.is_a?(MotifModel::NamedModel) && acts_as_pcm?(pcm.model)
    end

    class PCM < PM
      def self.count_validator(eps: 1.0e-4)
        Validator.new{|matrix, alphabet|
          errors = []
          unless matrix.all?{|pos| pos.all?{|el| el >= 0 } }
            errors << "Elements of PCM should be non-negative."
          end

          warnings = []
          if eps
            counts = matrix.map{|pos| pos.inject(0.0, &:+) }
            unless (counts.max - counts.min) <= eps * counts.min
              warnings << "PCM counts are different (discrepancy is greater than eps * MinCount; eps=#{eps}; MinCountn=#{counts.min})."
            end
          end

          ValidationResult.new(errors: errors, warnings: warnings)
        }
      end

      VALIDATOR = PM::VALIDATOR * PCM.count_validator(eps: 1.0e-4).make_strict
      DIFFERENT_COUNTS_VALIDATOR = PM::VALIDATOR * PCM.count_validator(eps: nil).make_strict


      def self.default_validator
        PCM::VALIDATOR
      end

      def initialize(matrix, alphabet: NucleotideAlphabet, validator: default_validator)
        super
        # validator already checked count discrepancy. We store median count.
        @count = matrix.map{|pos| pos.inject(0.0, &:+) }.sort[matrix.length / 2]
      end
      attr_reader :count
    end
  end
end
