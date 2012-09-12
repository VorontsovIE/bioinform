require 'spec_helper'
require 'yaml'
require 'bioinform/parsers/yaml_parser'
require 'bioinform/data_models/collection'

module Bioinform
  describe YAMLParser do
    context '#parser!' do
      it 'should return PM that was encoded in YAML format' do
        pm = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix name')
        parser = YAMLParser.new(pm.to_yaml)
        parser.parse!.should == pm
      end
      it 'should return PMs which were in encoded YAML format' do
        pm_1 = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix-1 name')
        pm_2 = PM.new(matrix:[[15,16,17,18],[11,12,13,14]], name:'Matrix-2 name')
        collection = Collection.new
        collection << pm_1 << pm_2
        parser = YAMLCollectionParser.new(collection.to_yaml)
        parser.parse!.should == pm_1
        parser.parse!.should == pm_2
        expect{ parser.parse! }.to raise_error
      end
    end
    it 'can be used to create PM from yaml-string' do
      pm = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix name')
      pm_copy = PM.new(pm.to_yaml, YAMLParser)
      pm_copy.should == pm
    end

    context '::split_on_motifs' do
      it 'should be able to split collection into PMs' do
        pm_1 = PM.new(matrix:[[1,2,3,4],[5,6,7,8]], name:'Matrix-1 name')
        pm_2 = PM.new(matrix:[[15,16,17,18],[11,12,13,14]], name:'Matrix-2 name')
        collection = Collection.new
        collection << pm_1 << pm_2
        result = YAMLCollectionParser.split_on_motifs(collection.to_yaml)
        result.should == [pm_1, pm_2]
      end
    end
  end
end
