require_relative 'pm'

module Bioinform
  module MotifModel
    class PPM < PM
      def validation_errors
        errors = super
        errors << "elements of PPM should be non-negative"  unless matrix.all?{|pos| pos.all?{|el| el >= 0 } }
        errors << "each PPM position should be equal to 1.0 being summed"  unless matrix.all?{|pos| (pos.inject(0.0, &:+) - 1.0).abs < 1e-3 }
        errors
      end
    end
  end
end