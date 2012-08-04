require 'bioinform/support'
require 'bioinform/data_models/pm'
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
      word = word.upcase
      raise ArgumentError, 'word in PWM#score(word) should have the same length as matrix'  unless word.length == length
      raise ArgumentError, 'word in PWM#score(word) should have only ACGT-letters'  unless word.each_char.all?{|letter| %w{A C G T}.include? letter}
      #word.each_char.map.with_index{|letter, pos| matrix[pos][IndexByLetter[letter]] }.inject(&:+)
      (0...length).inject(0){|sum, idx| sum + matrix[idx][IndexByLetter[word[idx]]] }
    end
  end
end