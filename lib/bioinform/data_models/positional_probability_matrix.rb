class PositionalProbabilityMatrix < PositionalMatrix
  attr_accessor :count
  def initialize(input_string)
    super(input_string)
    raise ArgumentError, 'PPM has negative matrix elements' unless @matrix.all?{|position| position.all?{|el| el>=0 }} 
    # summary counts can slightly differ from each other due to floating point precision
    unless @matrix.all?{|position| (position.inject(:+) - 1.0).abs < 0.01 }
      raise ArgumentError, 'PPM has summary probability at some position that differs from 1.0'
    end
  end
  def to_pcm
    PositionalCountMatrix.new @matrix.map{|pos| pos.map{|el| el*@count}}
  end
  def to_pwm
    to_pcm.to_pwm
  end
end