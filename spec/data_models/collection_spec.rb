require_relative '../spec_helper'
require_relative '../../lib/bioinform/data_models/collection'

module Bioinform
  describe Collection do
    before :each do
      @collection = Collection.new(name: 'Main collection')
      @pm_1 = Fabricate(:pm_1)
      @pm_2 = Fabricate(:pm_2)
      @pm_3 = Fabricate(:pm_3)
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
        @collection.should include(Motif.new(pm: @pm_1), Motif.new(pm: @pm_2), Motif.new(pm: @pm_3))
      end
      it 'should be chainable' do
        @collection << @pm_1 << @pm_2 << @pm_3
        @collection.should include(Motif.new(pm: @pm_1), Motif.new(pm: @pm_2), Motif.new(pm: @pm_3))
      end
    end

    describe '#each' do
      before :each do
        @collection << @pm_1 << @pm_2 << @pm_3
      end
      context 'with block given' do
        it 'should yield Motifs' do
          expect{|b| @collection.each(&b)}.to yield_successive_args(Motif,Motif,Motif)
        end
      end
      context 'with block given' do
        it 'return an Enumerator' do
          @collection.each.should be_kind_of(Enumerator)
        end
      end
    end

    describe '#each(:pcm)' do
      before :each do
        @collection << Fabricate(:pcm_1) << @pm_2 << Fabricate(:pcm_3)
      end
      context 'with block given' do
        it 'should yield elements of collecton converted to pcm' do
          expect{|b| @collection.each(:pcm, &b)}.to yield_successive_args(PCM, nil, PCM)
        end
      end
      context 'with block given' do
        it 'return an Enumerator' do
          @collection.each(:pcm).should be_kind_of(Enumerator)
        end
      end
    end

    describe '#+' do
      before :each do
        @collection << @pm_1 << @pm_2 << @pm_3
        @pm_sec_1 = Fabricate(:pm_4)
        @pm_sec_2 = Fabricate(:pm_5)
        @secondary_collection = Collection.new(name: 'Secondary collection')
        @secondary_collection << @pm_sec_1 << @pm_sec_2
        @summary_collection = @collection + @secondary_collection
      end
      it 'should create a collection consisting of all elements of both collections' do
        @summary_collection.should be_kind_of(Collection)
        @summary_collection.size.should == (@collection.size + @secondary_collection.size)
        @summary_collection.should include(Motif.new(pm: @pm_1), Motif.new(pm: @pm_2), Motif.new(pm: @pm_3), 
                                          Motif.new(pm: @pm_sec_1), Motif.new(pm: @pm_sec_2))
      end
    end
  end
end
