require 'spec_helper'
require 'bioinform/data_models/pm'

describe PM do
  describe '::valid?' do
    it 'should be true iff an argument is an array of arrays of 4 numerics in a column' do
      PM.valid?( [[1,2,3,4],[1,4,5,6.5]] ).should be_true
      PM.valid?( A: [1,1], C: [2,4], G: [3,5], T: [4, 6.5] ).should be_false
      PM.valid?( [{A:1,C:2,G:3,T:4},{A:1,C:4,G:5,T: 6.5}] ).should be_false
      PM.valid?( [[1,2,3,4],[1,4,6.5]] ).should be_false
      PM.valid?( [[1,2,3],[1,4,6.5]] ).should be_false
      PM.valid?( [[1,2,'3','4'],[1,'4','5',6.5]] ).should be_false
    end
  end
  describe '#matrix=' do
    it 'should replace matrix if argument is a valid matrix' do
      @pm = PM.new
      @pm.matrix.should be_nil
      @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
      @pm.matrix.should == [[1,2,3,4],[1,4,5,6.5]]
    end
    it 'should raise an exception if argument isn\'t valid matrix' do
      @pm = PM.new
      expect{  @pm.matrix = [[1,2,3,4],[1,4,5]]  }.to raise_error
    end
  end
  describe '#to_s' do
    before :each do
      @pm = PM.new
      @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
    end
    it 'should return string with single-tabulated multiline matrix' do
      @pm.to_s.should == "1\t2\t3\t4\n1\t4\t5\t6.5"
    end
    it 'should return positions in rows, letters in cols' do
      @pm.to_s.split("\n").size.should == 2
      @pm.to_s.split("\n").map{|pos| pos.split.size}.all?{|sz| sz==4}.should be_true
    end
    context 'with name specified' do
      before :each do
        @pm.name = 'Stub name'
      end
      it 'should return a string with a name and a matrix from the next line' do
        @pm.to_s.should == "Stub name\n1\t2\t3\t4\n1\t4\t5\t6.5"
      end
      it 'should not return a name if argument is set to false' do
        @pm.to_s(false).should == "1\t2\t3\t4\n1\t4\t5\t6.5"
      end
    end
  end
  
  describe '#pretty_string' do
    it 'should return a string formatted with spaces'
    it 'should contain first string of ACGT letters'
  end
  describe '#size' do
    it 'should return number of positions' do
      @pm = PM.new
      @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
      @pm.size.should == 2
    end
  end
  describe '#to_hash' do
    before :each do
      @pm = PM.new
      @pm.matrix = [[1,2,3,4],[1,4,5,6.5]]
      @hsh = @pm.to_hash
    end
    it 'should return a hash with keys A, C, G, T' do
      @hsh.should be_kind_of Hash
      @hsh.keys.sort.should == %w{A C G T}
    end
    it 'should contain matrix elements of corresponding letter' do
      @hsh['A'].should == [1, 1]
      @hsh['C'].should == [2, 4]
      @hsh['G'].should == [3, 5]
      @hsh['T'].should == [4, 6.5]
    end
    it 'should be accessible both by name and symbol (e.g. pm.to_hash[:A] or pm.to_hash[\'A\'] is the same)' do
      @hsh['A'].should == @hsh[:A]
      @hsh['C'].should == @hsh[:C]
      @hsh['G'].should == @hsh[:G]
      @hsh['T'].should == @hsh[:T]
    end
  end
  
end