class Iupac
  attr_reader :words
  def initialize(input)
    case input
    when Array
      @words = input.map{|word| IupacWord.new word}
    when String
      @words = input.gsub("\r\n","\n").split("\n").map{|word| IupacWord.new(word)}
    when IupacWord
      @words = [input]
    else raise ArgumentError, 'Can\'t create IUPAC Word List: unknown input type'
    end
    raise ArgumentError, 'IUPAC words should be of the same length' unless @words.same_by?(&:length)
  end
  
  def to_pcm
    @words.map(&:to_pcm).inject(:+)
  end
  def to_pwm
    to_pcm.to_pwm
  end
end