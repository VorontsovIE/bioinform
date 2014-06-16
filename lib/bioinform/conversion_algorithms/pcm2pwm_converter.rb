require_relative '../error'
require_relative '../data_models_2/pcm'
require_relative '../data_models_2/pwm'
require_relative '../data_models'
require_relative '../background'

module Bioinform
  module ConversionAlgorithms
    # s_{\alpha,j} = ln(\frac{x_{\alpha,j} + \cappa p_{\alpha}}{(N+\cappa)p_{\alpha}})
    module PCM2PWMConverter
      def self.convert(pcm, parameters = {})
        default_parameters = {pseudocount: Math.log(pcm.count),
                              probability: (pcm.probability || [0.25, 0.25, 0.25, 0.25])
                              }
        parameters = default_parameters.merge(parameters)
        probability = parameters[:probability]
        pseudocount = parameters[:pseudocount]
        matrix = pcm.each_position.map do |pos|
          pos.each_index.map do |index|
            Math.log((pos[index] + probability[index] * pseudocount) / (probability[index]*(pcm.count + pseudocount)) )
          end
        end
        PWM.new(matrix: matrix, name: pcm.name, background: pcm.background)
      end
    end

    class PCM2PWMConverter_
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
