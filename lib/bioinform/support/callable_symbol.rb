require 'bioinform/support/curry_except_self'

# Useful extension for &:symbol - syntax to make it possible to pass arguments for method in block
#   ['abc','','','def','ghi'].tap(&:delete.('')) # ==> ['abc','def','ghi']
#   [1,2,3].map(&:to_s.(2)) # ==> ['1','10','11']
class Symbol
  def call(*args, &block)
    obj=Object.new.instance_exec(self,args,block) do |sym,params,block| 
      @sym=sym
      @args = params
      @block = block
      self
    end
    obj.define_singleton_method :to_proc do
      @sym.to_proc.curry_except_self(*@args, &@block)
    end
    obj
  end
end