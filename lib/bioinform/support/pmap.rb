require 'bioinform/support/curry_except_self'

module Enumerable
  def pmap!(*args,&block)
    map! &block.curry_except_self(*args)
  end
  def pmap(*args,&block)
    dup.pmap!(*args, &block)
  end
end