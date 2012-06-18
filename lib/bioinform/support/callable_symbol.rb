require 'bioinform/support/curry_except_self'

# Useful extension for &:symbol - syntax to make it possible to pass arguments for method in block
#   ['abc','','','def','ghi'].tap(&:delete.(''))             # ==> ['abc','def','ghi']
#   [1,2,3].map(&:to_s.(2))                                  # ==> ['1','10','11']
#   ['abc','cdef','xy','z','wwww'].select(&:size.() == 4)    # ==> ['cdef', 'wwww']
#   ['abc','aaA','AaA','z'].count(&:upcase.().succ == 'AAB') # ==> 2
#   [%w{1 2 3 4 5},%w{6 7 8 9}].map(&:join.().length)         # ==> [5,4]
class Symbol
  def call(*args, &block)
    obj=BasicObject.new.instance_exec(self,args,block) do |sym,params,block| 
      
      @postprocess_meth = [sym]
      @postprocess_args = [params]
      @postprocess_block = [block]
      self
    end
    
    def obj.to_proc
      #res = @sym.to_proc.curry_except_self(*@args, &@block)
      
      # proc/lambda are methods that cannot be used in BasicObject. It's possible to use ->(slf){...} syntax since ruby-1.9.3 p194 but it's too modern and not widely spreaded yet
      ::Proc.new do |slf| 
        @postprocess_meth.zip(@postprocess_args,@postprocess_block).inject(slf) do |result,(call_meth,call_args,call_block)| 
          result.send(call_meth, *call_args,&call_block) 
        end
      end
    end
    
    def obj.method_missing(meth,*args,&block)
      @postprocess_meth << meth
      @postprocess_args << args
      @postprocess_block << block
      self
    end
    def obj.==(other)
      method_missing(:==, other)
    end
    def obj.!(other)
      method_missing(:!, other)
    end
    obj
  end
end