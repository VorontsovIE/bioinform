require_relative '../support'
require_relative '../data_models'
require_relative '../conversion_algorithms/pwm2pcm_converter'

module Bioinform
  class PWM < PM
    def score_mean
      each_position.inject(0){ |mean, position| mean + position.each_index.inject(0){|sum, letter| sum + position[letter] * probability[letter]} }
    end
    def score_variance
      each_position.inject(0) do |variance, position|
        variance  + position.each_index.inject(0) { |sum,letter| sum + position[letter]**2 * probability[letter] } -
                    position.each_index.inject(0) { |sum,letter| sum + position[letter]    * probability[letter] }**2
      end
    end

    def threshold_gauss_estimation(pvalue)
      sigma = Math.sqrt(score_variance)
      n_ = Math.inverf(1 - 2 * pvalue) * Math.sqrt(2)
      score_mean + n_ * sigma
    end

    def score(word)
      raise ArgumentError, 'word in PWM#score(word) should have the same length as matrix'  unless word.length == length
      #raise ArgumentError, 'word in PWM#score(word) should have only ACGT-letters'  unless word.each_char.all?{|letter| %w{A C G T}.include? letter}
      (0...length).map do |pos|
        letter = word[pos]
        if IndexByLetter[letter]
          matrix[pos][IndexByLetter[letter]]
        elsif letter == 'N'
          matrix[pos].zip(probability).map{|el, p| el * p}.inject(0, &:+)
        else
          raise ArgumentError, "word in PWM#score(#{word}) should have only ACGT or N letters"
        end
      end.inject(0, &:+).to_f
    end

    def to_pwm
      self
    end

    def best_score
      best_suffix(0)
    end
    def worst_score
      worst_suffix(0)
    end

    # best score of suffix s[i..l]
    def best_suffix(i)
      @matrix[i...length].map(&:max).inject(0.0, &:+)
    end

    def worst_suffix(i)
      @matrix[i...length].map(&:min).inject(0.0, &:+)
    end


    def matrix_rounded(n)
      matrix.map{|pos| pos.map{|x| x.round(n) } }
    end
    private :matrix_rounded

    def round(n)
      PWM.new(matrix_rounded(n)).tap{|pm| pm.name = name}
    end
  end
end
