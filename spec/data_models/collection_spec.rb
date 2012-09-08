require 'spec_helper'
require 'bioinform/data_models/collection'

module Bioinform
  describe Collection do
    before :each do
      @collection = Collection.new('Main collection')
      @pm_1 = PM.new(matrix:[[1,1,1,1]],name:'Stub datamodel')
      @pm_2 = PM.new(matrix:[[1,2,3,4],[4,3,2,1]],name:'Second stub')
      @pm_3 = PM.new(matrix:[[11,12,13,14],[41,31,21,11]],name:'Third stub')
    end
    describe '#size' do
      it 'should return size of collection' do
        @collection << @pm_1 << @pm_2 << @pm_3
        @collection.size.should == 3
      end
    end
    describe '#<<' do
      it 'should add element to collection' do
        @collection << @pm_1
        @collection << @pm_2
        @collection << @pm_3
        @collection.collection[0].should be_eql(@pm_1)
        @collection.collection[1].should be_eql(@pm_2)
        @collection.collection[2].should be_eql(@pm_3)
      end
      it 'should be chainable' do
        @collection << @pm_1 << @pm_2 << @pm_3
        @collection.collection[0].should be_eql(@pm_1)
        @collection.collection[1].should be_eql(@pm_2)
        @collection.collection[2].should be_eql(@pm_3)
      end
    end
    
    describe '#each' do
      before :each do
        @collection << @pm_1 << @pm_2 << @pm_3
      end
      context 'with block given' do
        it 'should yield elements of collecton' do
          expect{|b| @collection.each(&b)}.to yield_successive_args(@pm_1, @pm_2, @pm_3)
        end
      end
      context 'with block given' do
        it 'return an Enumerator' do
          @collection.each.should be_kind_of(Enumerator)
        end
      end
    end
    
    describe '#+' do
      before :each do
        @collection << @pm_1 << @pm_2 << @pm_3
        @pm_sec_1 = PM.new(matrix: [[1,0,1,0],[0,0,0,0],[1,2,3,4]], name: 'Secondary collection matrix 1')
        @pm_sec_2 = PM.new(matrix: [[1,2,1,2],[0,3,6,9],[1,2,3,4]], name: 'Secondary collection matrix 2')
        @secondary_collection = Collection.new('Secondary collection')
        @secondary_collection << @pm_sec_1 << @pm_sec_2
        @summary_collection = @collection + @secondary_collection
      end
      it 'should create a collection consisting of all elements of both collections' do
        @summary_collection.should be_kind_of(Collection)
        @summary_collection.size.should == (@collection.size + @secondary_collection.size)
        @summary_collection.collection.should include(@pm_1, @pm_2, @pm_3, @pm_sec_1, @pm_sec_2)
      end
    end
  end
end