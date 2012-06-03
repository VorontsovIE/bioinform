require 'spec_helper'
require 'bioinform/support/has_keys'

describe Hash do
  describe '#has_all_keys?' do
    it 'should be true if all given keys are at place' do
      {a: 3, b: 6, c: 7, d: 13}.has_all_keys?(:a, :c).should be_true
    end
    
    it 'should be false if any given of keys is missing' do
      {a: 3, b: 6, c: 7, d: 13}.has_all_keys?(:a, :x).should be_false
    end
  end
  
  describe '#has_any_key?' do
    it 'should be true if any of given keys is at place' do
      {a: 3, b: 6, c: 7, d: 13}.has_any_key?(:a, :x).should be_true
    end
    
    it 'should be false if no one of given is missing' do
      {a: 3, b: 6, c: 7, d: 13}.has_any_key?(:x, :y).should be_false
    end
  end
  
  describe '#has_none_key?' do
    it 'should be true if all given keys are missing' do
      {a: 3, b: 6, c: 7, d: 13}.has_none_key?(:x, :y).should be_true
    end
    
    it 'should be false if any of given keys is at place' do
      {a: 3, b: 6, c: 7, d: 13}.has_none_key?(:a, :y).should be_false
    end
  end
  
  describe '#has_one_key?' do
    it 'should be true if one of given keys is present' do
      {a: 3, b: 6, c: 7, d: 13}.has_one_key?(:x, :a).should be_true
    end
    
    it 'should be false if many of given keys are present' do
      {a: 3, b: 6, c: 7, d: 13}.has_one_key?(:a, :c).should be_false
    end
    
    it 'should be false if none of given keys is at place' do
      {a: 3, b: 6, c: 7, d: 13}.has_one_key?(:x, :y).should be_false
    end
  end
end