require 'spec_helper'
require 'bioinform/support/inverf'

describe 'Math#inverf' do
  it 'should be erf(inverf(x)) == x' do
    rng = (-0.9..0.9).step(0.1)
    arr = rng.to_a
    arr2 = rng.map{|x| Math.inverf(x)}.map{|x| Math.erf(x)}
    delta = arr.each_index.map{|i| (arr[i] - arr2[i]).abs }
    delta.each{|el| el.should <= 0.001}
  end
  it 'should be erf(inverf(x)) == x' do
    rng = (-5..5).step(1)
    arr = rng.to_a
    arr2 = rng.map{|x| Math.erf(x)}.map{|x| Math.inverf(x)}
    delta = arr.each_index.map{|i| (arr[i] - arr2[i]).abs }
    delta.each{|el| el.should <= 0.01}
  end
end