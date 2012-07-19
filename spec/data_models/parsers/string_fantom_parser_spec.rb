require 'spec_helper'
require 'bioinform/data_models/parsers'

module Bioinform
  describe StringFantomParser do
    before :each do
      @matrix = [[0.0, 1878368.0, 0.0, 0.0], 
                 [0.0, 0.0, 0.0, 1878368.0], 
                 [469592.0, 469592.0, 469592.0, 469592.0], 
                 [0.0, 1878368.0, 0.0, 0.0], 
                 [1878368.0, 0.0, 0.0, 0.0], 
                 [0.0, 0.0, 1878368.0, 0.0]]
      
      @good_input = <<-EOS
        NA  motif_CTNCAG					
        P0	A	C	G	T	
        P1	0	1878368	0	0	
        P2	0	0	0	1878368	
        P3	469592	469592	469592	469592	
        P4	0	1878368	0	0	
        P5	1878368	0	0	0	
        P6	0	0	1878368	0	
      EOS
    end
    
    describe '#can_parse?' do
      it 'should parse particular kind of string' do
        StringFantomParser.new(@good_input).can_parse?.should be_true
      end
    end
    
    describe '#parse' do
      it 'should parse particular kind of string' do
        StringFantomParser.new(@good_input).parse.should == { matrix: @matrix, name: 'motif_CTNCAG'}
      end
    end
  end
end