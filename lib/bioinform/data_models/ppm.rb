require_relative '../support'
require_relative '../data_models'

module Bioinform
  class PPM < PM
    attr_accessor :effective_count, :pseudocount

    def self.valid_matrix?(matrix, options = {})
      precision = options[:precision] || 0.01
      super && matrix.all?{|pos| ((pos.inject(0, &:+) - 1.0).abs <= precision)  && pos.all?{|el| el >=0 } }
    end

    def validation_errors(options = {})
      precision = options[:precision] || 0.01
      validation_errors = []
      validation_errors << "PPM matrix should contain only non-negative elements"  unless matrix.all?{|pos| pos.all?{|el| el >=0 } }
      validation_errors << "Sum of PPM matrix elements for each position should equal to 1"  unless matrix.all?{|pos| ((pos.inject(0, &:+) - 1.0).abs <= precision) }
      super + validation_errors
    end
  end
end
