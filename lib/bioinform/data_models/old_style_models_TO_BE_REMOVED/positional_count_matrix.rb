class PositionalCountMatrix < PositionalMatrix
  attr_accessor :pseudocount, :background
  def initialize(*args)
    super
    raise ArgumentError, 'PCM has negative matrix elements' unless @matrix.all?{|position| position.all?{|el| el>=0 }}
    raise ArgumentError, 'PCM summary count is zero or negative' unless count>=0
    # summary counts can slightly differ from each other due to floating point precision
    unless @matrix.all?{|position| (position.inject(:+) - count).abs < 0.01*count } 
      raise ArgumentError, 'PCM has different summary count at each position'
    end
    @background = [1.0, 1.0, 1.0, 1.0]
    @pseudocount = 1.0
  end
  def count
    @count ||= @matrix.first.inject(&:+)
  end
  def to_pwm
    normalize_coef = background.inject(&:+)
    bckgr = @background.map{|el| el*1.0/normalize_coef}
    PositionalWeightMatrix.new @matrix.map{|pos| pos.map.with_index{|el,ind| Math.log(el+bckgr[ind]*@pseudocount /(bckgr[ind]*(count + @pseudocount))) }}
  end
  def +(another_pcm)
    raise ArgumentError, 'another PCM should be of the same length' unless another_pcm.length == length
    PositionalCountMatrix.new matrix.map.with_index {|pos, i| pos.map.with_index{|el,j| el+another_pcm.matrix[i][j] }}
  end
end
