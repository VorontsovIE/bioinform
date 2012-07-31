require 'bioinform/support'
require 'bioinform/data_models/pm'
module Bioinform
  class PCM < PM
    def count
      matrix.first.inject(&:+)
    end
    
    def to_pwm(pseudocount = Math.log(count))
      mat = each_position.map do |pos|
        pos.each_index.map do |ind|
          Math.log((pos[ind] + probability[ind] * pseudocount) / (probability[ind]*(count + pseudocount)) )
        end
      end
      PWM.new(mat)
    end

  end
end