require 'bioinform/support/curry_except_self'

class Symbol
  def call(*args)
    obj=Object.new.instance_exec(self,args){|sym,params| @sym=sym; @args = params; self}
    obj.define_singleton_method :to_proc do
      @sym.to_proc.curry_except_self(*@args)
    end
    obj
  end
end