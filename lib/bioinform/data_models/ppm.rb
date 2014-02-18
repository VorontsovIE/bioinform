require_relative '../support'
require_relative '../data_models'

module Bioinform
  class PPM < PM
    def to_ppm
      self
    end
    def self.valid_matrix?(matrix, precision = 0.001)
      matrix.all?{|pos| ((pos.inject(0, &:+) - 1.0).abs <= precision)  && pos.all?{|el| el >=0 } }
    end
  end
end