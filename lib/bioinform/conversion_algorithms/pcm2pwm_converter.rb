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
  end
end
