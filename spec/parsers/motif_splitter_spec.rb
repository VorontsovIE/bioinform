=begin 
require 'spec_helper'
require 'bioinform/parsers/motif_splitter'

module Bioinform
  describe '#split_onto_motifs' do
    it 'should be able to get a single PM' do
      Bioinform.split_onto_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12").map{|x| PM.new(x).matrix}.should == [ [[1,2,3,4],[5,6,7,8],[9,10,11,12]] ]
    end
    it 'should be able to split several PMs separated with an empty line' do
      Bioinform.split_onto_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \n\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").map{|x| PM.new(x).matrix}.should == [ [[1,2,3,4],[5,6,7,8],[9,10,11,12]],[[9,10,11,12],[1,2,3,4],[5,6,7,8]] ]
    end
    it 'should be able to split several PMs separated with name' do
      Bioinform.split_onto_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \nname\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").map{|x| PM.new(x).matrix}.should == [ [[1,2,3,4],[5,6,7,8],[9,10,11,12]],[[9,10,11,12],[1,2,3,4],[5,6,7,8]] ]
      Bioinform.split_onto_motifs("1 2 3 4 \n 5 6 7 8 \n 9 10 11 12 \n\n 9 10 11 12 \n 1 2 3 4 \n 5 6 7 8").map{|x| PM.new(x).name}.should == [nil,'name']
    end
  end
end
=end