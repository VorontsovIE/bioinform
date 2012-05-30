class PM
  attr_reader :name, :matrix
  
  def size;  @matrix.size;   end
  alias_method :length, :size
  
  def to_s(with_name = true)
    mat_str = @matrix.pmap("\t",&:join).join("\n")
    (with_name && @name) ? "#{@name}\n#{mat_str}" : mat_str
  end
  
  def pretty_string(with_name = true)
    header = "   A      C      G      T   \n"
    mat_str = @matrix.map{|position|  position.map{|el| el.round(3).to_s.rjust(6)}.join(' ') }.join("\n")
    (with_name && @name)  ?  @name + "\n" + header + mat_str  :  header + mat_str
  end
  
  def to_hash
    {A: @matrix.map{|pos| pos[0]}, C: @matrix.map{|pos| pos[1]}, G: @matrix.map{|pos| pos[2]}, T: @matrix.map{|pos| pos[3]}}.with_indifferent_access
  end
  
end