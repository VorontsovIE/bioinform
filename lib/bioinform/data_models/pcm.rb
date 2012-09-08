require 'bioinform/support'
require 'bioinform/data_models'

module Bioinform
  class PCM < PM
    def count
      matrix.first.inject(&:+)
    end

    def to_pcm
      self
    end

    def to_pwm(pseudocount = Math.log(count))
      mat = each_position.map do |pos|
        pos.each_index.map do |ind|
          Math.log((pos[ind] + probability[ind] * pseudocount) / (probability[ind]*(count + pseudocount)) )
        end
      end
      PWM.new(matrix: mat, name: name, tags: tags, background: background)
    end

    def to_ppm
      mat = each_position.map{|pos| pos.map{|el| el.to_f / count }}
      PPM.new(matrix: mat, name: name, tags: tags, background: background)
    end
  end
end