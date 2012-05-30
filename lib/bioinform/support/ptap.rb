require 'bioinform/support/curry_except_self'
class Object
  def ptap(*args,&block)
    tap &block.curry_except_self(*args)
  end
end

