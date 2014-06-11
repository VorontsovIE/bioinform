require_relative 'pm'

module Bioinform
  module MotifModel
    class PPM < PM
      def valid?
        super && matrix.all?{|pos|
          (pos.inject(0.0, &:+) - 1.0).abs < 1e-3 && pos.all?{|el| el >= 0 }
        }
      end
    end
  end
end
