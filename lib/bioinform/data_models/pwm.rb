require 'bioinform/support'
require 'bioinform/data_models/pm'
module Bioinform

  class PWM < PM
    def score_mean
      matrix.inject(0.0){ |mean, position| mean + position.each_index.inject(0.0){|sum, letter| sum + position[letter] * probability[letter]} }
    end
    
    def score_variance
      matrix.inject(0.0) do |variance, position|
        variance  + position.each_index.inject(0.0) { |sum,letter| sum + position[letter]**2 * probability[letter] } -
                    position.each_index.inject(0.0) { |sum,letter| sum + position[letter]    * probability[letter] }**2
      end
    end
    
    def threshold_gauss_estimation(pvalue)
      sigma = Math.sqrt(score_variance)
      n_ = inverf(1 - 2 * pvalue) * Math.sqrt(2)
      score_mean + n_ * sigma
    end
  end
end