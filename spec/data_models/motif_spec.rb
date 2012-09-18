require_relative '../../lib/bioinform/data_models/motif'
module Bioinform
  describe Motif do
    it 'should' do
      Fabricate(:motif).pcm = 'xxx'
    end
  end
end