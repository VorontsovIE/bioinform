module Bioinform
  module ConversionAlgorithms
    # pcm --> pwm:
    #   s_{\alpha,j} = ln(\frac{x_{\alpha,j} + \cappa p_{\alpha}}{(N+\cappa)p_{\alpha}}) - \beta_{j}
    #   \beta_j is an arbitrary constant
    # pwm --> pcm:
    #   x_{\alpha,j} = (N + \cappa) p_{\alpha} \exp{ s_{\alpha,j} - \beta_j } - \cappa p_{\alpha}
    #   \beta_j = log(\sum_{\alpha}p_{\alpha}s_{\alpha,j})  because \sum_{\alpha} x_{\alpha,j} = N
    module PWM2PCMConverter

      # \sum p_{\alpha} s_{\alpha,j}
      def self.weighted_position_exponent(pos, probability)
        pos.each_with_index.map {|elem, letter_index| probability[letter_index] * Math.exp(elem) }.inject(0.0, &:+)
      end

      # possible  (pseudocount / count) range is from 0 to max_pseudocount_fraction
      # it's derived from
      # (-\exp{s_{\alpha,j}} + \sum_{\alpha} p_{\alpha,j}\exp{s_{\alpha,j}}) * pseudocount  <  count * \exp{s_{\alpha,j}}
      # which is derived from the fact that each element of PCM should be not less than 0
      def self.max_pseudocount_fraction(pwm_matrix, probability)
        # min = 0.0
        max = Float::INFINITY
        pwm_matrix.each do |pos|
          pos.each_with_index do |elem, letter_index|
            coeff = weighted_position_exponent(pos, probability) -  Math.exp(elem)
            if coeff > 0
              max = [Math.exp(elem) / coeff, max].min
            # elsif coeff < 0
              # min = [Math.exp(elem) / coeff, min].max
            end
          end
        end
        max
      end

      def self.convert(pwm, parameters = {})
        default_parameters = {count: 100.0,
                              pseudocount: 1.0,
                              probability: (pwm.probability || [0.25, 0.25, 0.25, 0.25]) }
        parameters = default_parameters.merge(parameters)
        count = parameters[:count]
        pseudocount = parameters[:pseudocount]
        probability = parameters[:probability]
        matrix = pwm.each_position.map do |pos|
          beta = Math.log( weighted_position_exponent(pos, probability) )
          pwm_pos = pos.each_index.map do |index|
            (count + pseudocount) * probability[index] * Math.exp( pos[index] ) * Math.exp( -beta ) - pseudocount * probability[index]
          end
          pwm_pos
        end
        PCM.new(pwm.get_parameters.merge(matrix: matrix))
      end
    end
  end
end