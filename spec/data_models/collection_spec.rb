require 'spec_helper'
require 'bioinform/data_models/'

module Bioinform
  describe Collection do
    before :each do
      @ = Collection.new('Main ')
      @pm_1 = PM.new(matrix:[[1,1,1,1]],name:'Stub datamodel')
      @pm_2 = PM.new(matrix:[[1,2,3,4],[4,3,2,1]],name:'Second stub')
      @pm_3 = PM.new(matrix:[[11,12,13,14],[41,31,21,11]],name:'Third stub')
    end
    describe '#size' do
      it 'should return size of ' do
        @ << @pm_1 << @pm_2 << @pm_3
        @.size.should == 3
      end
    end
    describe '#<<' do
      it 'should add element to ' do
        @ << @pm_1
        @ << @pm_2
        @ << @pm_3
        @.[0].should be_eql(@pm_1)
        @.[1].should be_eql(@pm_2)
        @.[2].should be_eql(@pm_3)
      end
      it 'should be chainable' do
        @ << @pm_1 << @pm_2 << @pm_3
        @.[0].should be_eql(@pm_1)
        @.[1].should be_eql(@pm_2)
        @.[2].should be_eql(@pm_3)
      end
      it 'should mark motif with name' do
        @ << @pm_1 << @pm_2
        @pm_1.should be_tagged('Main ')
        @pm_2.should be_tagged('Main ')
      end
      it 'should mark motif with self' do
        @ << @pm_1 << @pm_2
        @pm_1.should be_tagged(@)
        @pm_2.should be_tagged(@)
      end
    end
    
    describe '#each' do
      before :each do
        @ << @pm_1 << @pm_2 << @pm_3
      end
      context 'with block given' do
        it 'should yield elements of collecton' do
          expect{|b| @.each(&b)}.to yield_successive_args(@pm_1, @pm_2, @pm_3)
        end
      end
      context 'with block given' do
        it 'return an Enumerator' do
          @.each.should be_kind_of(Enumerator)
        end
      end
    end
    
    describe '#+' do
      before :each do
        @ << @pm_1 << @pm_2 << @pm_3
        @pm_sec_1 = PM.new(matrix: [[1,0,1,0],[0,0,0,0],[1,2,3,4]], name: 'Secondary  matrix 1')
        @pm_sec_2 = PM.new(matrix: [[1,2,1,2],[0,3,6,9],[1,2,3,4]], name: 'Secondary  matrix 2')
        @secondary_ = Collection.new('Secondary ')
        @secondary_ << @pm_sec_1 << @pm_sec_2
        @summary_ = @ + @secondary_
      end
      it 'should create a  consisting of all elements of both s' do
        @summary_.should be_kind_of(Collection)
        @summary_.size.should == (@.size + @secondary_.size)
        @summary_..should include(@pm_1, @pm_2, @pm_3, @pm_sec_1, @pm_sec_2)
      end
      it 'should leave marks on motifs' do
        @pm_1.should be_tagged('Main ')
        @pm_sec_1.should be_tagged('Secondary ')
      end
      it 'should not mix marks of motifs in different s' do
        @pm_1.should_not be_tagged('Secondary ')
        @pm_sec_1.should_not be_tagged('Main ')
      end
    end
  end
end