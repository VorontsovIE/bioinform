require_relative '../support'
require_relative '../data_models'
require_relative '../conversion_algorithms/pcm2ppm_converter'
require_relative '../conversion_algorithms/pcm2pwm_converter'

module Bioinform
  class PCM < PM
    attr_accessor :pseudocount

    def count
      matrix.first.inject(&:+)
    end

    def self.valid_matrix?(matrix, options = {})
      super && matrix.all?{|pos| pos.all?{|el| el >=0 } }
    end

    def validation_errors(options = {})
      validation_errors = []
      validation_errors << "PCM matrix should contain only non-negative elements"  unless matrix.all?{|pos| pos.all?{|el| el >=0 } }
      super + validation_errors
    end
  end
end
