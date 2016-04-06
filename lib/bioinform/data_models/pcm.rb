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

      def initialize(matrix, alphabet: NucleotideAlphabet, validator: PCM::VALIDATOR)
        super
        # validator already checked count discrepancy. We store median count.
        @count = matrix.map{|pos| pos.inject(0.0, &:+) }.sort[matrix.length / 2]
      end
      attr_reader :count


      # log_fact(n) := ln(n!)
      def log_fact(x)
        Math.lgamma(x + 1).first
      end
      private :log_fact

      def position_discrete_information_content(pos)
        words_count = pos.inject(0.0, &:+)
        ( pos.map{|x| log_fact(x) }.inject(0.0, &:+) - log_fact(words_count) ) / words_count
      end
      private :position_discrete_information_content

      def discrete_information_content
        each_position.map{|pos| position_discrete_information_content(pos) }.inject(0.0, &:+)
      end
      alias_method :dic, :discrete_information_content

      def position_discrete_kullback_leibler_divergence(pos, background_frequencies)
        words_count = pos.inject(0.0, &:+)
        subtrahend = pos.zip(background_frequencies).map{|letter_count, letter_background_frequency|
          (letter_count / words_count) * Math.log(letter_background_frequency)
        }.inject(0.0, &:+)
        position_discrete_information_content(pos) - subtrahend
      end

      def discrete_kullback_leibler_divergence(background_frequencies)
          each_position.map{|pos| position_discrete_kullback_leibler_divergence(pos, background_frequencies) }.inject(0.0, &:+)
      end
      alias_method :kdic, :discrete_kullback_leibler_divergence
    end
  end
end
