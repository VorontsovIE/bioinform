require_relative '../spec_helper'
require_relative '../../lib/bioinform/support/collect_hash'

describe Enumerable do
  # %w{A C G T}.collect_hash{|k| [k*2, k*3] }
  # # ==> {"AA" => "AAA", "CC" => "CCC", "GG" => "GGG", "TT" => "TTT"}
  context '#collect_hash' do
    it 'should take a block and create a hash from collected [k,v] pairs' do
      %w{A C G T}.collect_hash{|k| [k*2, k*3] }.should == {"AA" => "AAA", "CC" => "CCC", "GG" => "GGG", "TT" => "TTT"}
    end
    it 'should create a hash from yielded [k,v] pairs if block not given' do
      %w{A C G T}.each_with_index.collect_hash.should == {"A" => 0, "C" => 1, "G" => 2, "T" => 3}
    end
  end
end