require_relative '../error'
require_relative '../data_models_2/pcm'
require_relative '../data_models_2/pwm'
require_relative '../data_models'
require_relative '../background'

module Bioinform
  module ConversionAlgorithms
    # s_{\alpha,j} = ln(\frac{x_{\alpha,j} + \cappa p_{\alpha}}{(N+\cappa)p_{\alpha}})
    class PCM2PWMConverter
      def initialize(background: Bioinform::Background::Uniform, pseudocount: :log)
        @background = background
        @pseudocount = pseudocount
      end

      def calculate_pseudocount(pcm)
        case @pseudocount
        when Numeric
          @pseudocount
        when :log
          Math.log(pcm.count)
        when :sqrt
          Math.sqrt(pcm.count)
        when Proc
          @pseudocount.call(pcm)
        else
          raise Error, 'Unknown pseudocount type use numeric or :log or :sqrt or Proc with taking pcm parameter'
        end
      end

      def convert(pcm)
        raise Error, "#{self.class}#convert accepts only models acting as PCM"  unless MotifModel.acts_as_pcm?(pcm)
        actual_pseudocount = calculate_pseudocount(pcm)
        matrix = pcm.each_position.map do |pos|
          count = pos.inject(0.0, &:+)
          pos.each_index.map do |index|
            Math.log((pos[index] + @background.frequencies[index] * actual_pseudocount).to_f / (@background.frequencies[index]*(count + actual_pseudocount)) )
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
