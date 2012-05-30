class Proc
  def curry_except_self(*args)
    Proc.new{|slf| curry[slf,*args] }
  end
end
