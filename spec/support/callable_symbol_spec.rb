require 'spec_helper'
require 'bioinform/support/callable_symbol'

describe Symbol do
  describe '#call' do
    context 'returned object' do
      it 'should have to_proc method' do
        :to_s.().should respond_to :to_proc
        :to_s.(2).should respond_to :to_proc
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