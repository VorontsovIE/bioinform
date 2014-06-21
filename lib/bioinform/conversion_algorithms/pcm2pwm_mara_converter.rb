require_relative '../errors'
require_relative '../data_models'
require_relative '../background'

module Bioinform
  module ConversionAlgorithms
    # s_{\alpha,j} = ln(\frac{x_{\alpha,j} + \cappa p_{\alpha}}{(N+\cappa)p_{\alpha}})
    class MaraPCM2PWMConverter
      def convert(pcm)
        raise Error, "#{self.class}#convert accepts only models acting as PCM"  unless MotifModel.acts_as_pcm?(pcm)
        matrix = pcm.each_position.map do |pos|
          count = pos.inject(0.0, &:+)
          pos.each_index.map do |index|
            Math.log((pos[index] + 0.5).to_f / (0.25 * (count + 2)) )
          end
        end
        pwm = MotifModel::PWM.new(matrix)
        if pcm.respond_to? :name
          pwm.named(pcm.name)
        else
          pwm
        end
      end
    end
  end
end
