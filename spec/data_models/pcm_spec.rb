require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/pcm'

module Bioinform
  describe PCM do
    describe '#count' do
      it 'should be equal to sum of elements at position' do
        Fabricate(:pcm).count.should == 7
        Fabricate(:pcm_with_floats).count.should == 7.5
      end
    end
  end
end
