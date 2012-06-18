describe 'Array#partial_sums' do
  it 'should return an array of the same size with partial sums of elements 0..ind inclusive with float elements' do
    [2,3,4,5].partial_sums.should == [2, 5, 9, 14]
    [2,3,4,5].partial_sums.last.should be_kind_of(Float)
  end
  it 'should start counting from argument when it\'s given' do
    [2,3,4,5].partial_sums(100).should == [102,105,109,114]
  end
end