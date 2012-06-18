require 'spec_helper'
require 'bioinform/support/callable_symbol'

# TODO: organize and write more correct descriptions
describe Symbol do
  describe '#call' do
    context 'when symbol curries a block' do
      it 'should pass a block to a corresponding proc' do
        :map.(&:to_s).to_proc.call([1,2,3]).should == ['1','2','3']
        [[1,2,3],[4,5,6]].map(&:map.(&:to_s)).should == [['1','2','3'],['4','5','6']]
        [[1,2,3],[4,5,6]].map(&:map.(&:to_s.(2))).should == [['1','10','11'],['100','101','110']]
        ['abc','cdef','xy','z','wwww'].select(&:size.() == 4).should == ['cdef', 'wwww']
        
        [%w{1 2 3 4 5},%w{6 7 8 9 10}].map(&:join.().length).should == [5,6]  # method chaining
        ['abc','aaA','AaA','z'].count(&:upcase.().succ == 'AAB').should == 2 # method chaining with ==
        [[1,2,3]].map(  &:map.(&:to_s.(2)).map(&:to_i)  ).should == [[1,10,11]]  # method chaining with block on initial symbol and on later symbols
      end
    end
  
    context 'returned object' do
      
      it 'should have to_proc method' do
        expect { :to_s.() }.to respond_to :to_proc
        expect { :to_s.(2) }.to respond_to :to_proc
        expect { :to_s.(2) == '110' }.to respond_to :to_proc
        expect { :to_s.(2).postprocess('arg1','arg2') }.to respond_to :to_proc
      end
      
      context 'corresponding proc' do
        it 'should call method, corresponding to symbol, on first argument' do
          stub_obj = double('obj')
          stub_obj.should_receive(:to_s).exactly(:twice)
          prc_1 = :to_s.(2).to_proc
          prc_2 = :to_s.(2).to_proc # When used with &, to_proc can be omitted: it's implicitly casted on call (see other examples)
          prc_1.call(stub_obj) # These forms are almost equivalent, but second is much more concise
          stub_obj.tap(&prc_2)
        end
        context 'when multiple arguments of call specified' do
          it 'should call using given arguments' do
            stub_obj = double('obj')
            stub_obj.should_receive(:gsub).with('before','after')
            prc = :gsub.('before','after')
            stub_obj.tap(&prc)
          end
        end
        context 'when the only argument of call specified' do
          it 'should call using given argument' do
            stub_obj = double('obj')
            stub_obj.should_receive(:to_s).with(2)
            prc = :to_s.(2)
            stub_obj.tap(&prc)
          end
        end
        context 'when no arguments given' do
          it 'should call without any arguments' do
            stub_obj = double('obj')
            stub_obj.should_receive(:to_s).with()
            prc = :to_s.()
            stub_obj.tap(&prc)
          end
        end
      end
      
    end
  end
end