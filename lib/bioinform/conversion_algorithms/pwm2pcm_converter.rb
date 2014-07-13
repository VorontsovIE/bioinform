require_relative '../data_models'

module Bioinform
  module ConversionAlgorithms

    # This algorithm is a purely heuristic based on our algorithm of PWM calculation.
    # pcm --> pwm:
    #   s_{\alpha,j} = ln(\frac{x_{\alpha,j} + \cappa p_{\alpha}}{(N+\cappa)p_{\alpha}}) - \beta_{j}
    #   \beta_j is an arbitrary constant
    # Hence
    # pwm --> pcm:
    #   x_{\alpha,j} = (N + \cappa) p_{\alpha} \exp{ s_{\alpha,j} - \beta_j } - \cappa p_{\alpha}
    #   \beta_j = log(\sum_{\alpha}p_{\alpha}s_{\alpha,j})  because \sum_{\alpha} x_{\alpha,j} = N
    class PWM2PCMConverter
      attr_reader :pseudocount, :count, :background

      def initialize(options = {})
        @pseudocount = options.fetch(:pseudocount, :default)
        @count = options.fetch(:count, 100.0)
        @background = options.fetch(:background, Bioinform::Background::Uniform)
      end

      def calculate_pseudocount(pwm)
        case @pseudocount
        when Numeric
          @pseudocount
        when :default
          # *0.95 is to guarantee that rounding errors won't exceed real max pseudocount and generate PCM with negative elements
          max_pseudocount = max_pseudocount_fraction(pwm) * @count
          (Math.log(@count) <= max_pseudocount*0.95) ? Math.log(@count) : max_pseudocount * 0.95
        when Proc
          @pseudocount.call(pwm)
        else
          raise Error, 'Unknown pseudocount type use numeric or :default or Proc with taking pcm parameter'
        end
      end

      # \sum p_{\alpha} s_{\alpha,j}
      def weighted_position_exponent(pos)
        pos.each_with_index.map {|elem, letter_index| @background.frequencies[letter_index] * Math.exp(elem) }.inject(0.0, &:+)
      end

      # possible  (pseudocount / count) range is from 0 to max_pseudocount_fraction
      # it's derived from
      # (-\exp{s_{\alpha,j}} + \sum_{\alpha} p_{\alpha,j}\exp{s_{\alpha,j}}) * pseudocount  <  count * \exp{s_{\alpha,j}}
      # which is derived from the fact that each element of PCM should be not less than 0
      def max_pseudocount_fraction(pwm)
        # min = 0.0
        max = Float::INFINITY
        pwm.each_position do |pos|
          pos.each_with_index do |elem, letter_index|
            coeff = weighted_position_exponent(pos) -  Math.exp(elem)
            if coeff > 0
              max = [Math.exp(elem) / coeff, max].min
            # elsif coeff < 0
              # min = [Math.exp(elem) / coeff, min].max # Math.exp(elem) / coeff is always < 0 hence minimal pseudocount is zero
            end
          end
        end
        max
      end

      private :max_pseudocount_fraction, :weighted_position_exponent

      def convert(pwm)
        raise Error, "Can convert only PWMs"  unless MotifModel.acts_as_pwm?(pwm)
        actual_pseudocount = calculate_pseudocount(pwm)
        matrix = pwm.each_position.map do |pos|
          beta = Math.log( weighted_position_exponent(pos) )
          pwm_pos = pos.each_index.map do |index|
            (@count + actual_pseudocount) * @background.frequencies[index] * Math.exp( pos[index] ) * Math.exp( -beta ) - actual_pseudocount * @background.frequencies[index]
          end
          pwm_pos
        end

        pcm = MotifModel::PCM.new(matrix)
        if pwm.respond_to? :name
          pcm.named(pwm.name)
        else
          pcm
        end
      end
    end
  end
end
