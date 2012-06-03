class Proc
  def curry_except_self(*args, &block)
    Proc.new{|slf| curry.call(slf, *args, &block) }
  end
end
