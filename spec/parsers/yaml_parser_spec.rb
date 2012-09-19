require 'yaml'
require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/yaml_parser'
require_relative '../../lib/bioinform/data_models/collection'

module Bioinform
  describe YAMLParser do
    context '#parse!' do
      it 'should return PM that was encoded in YAML format' do
        pm = Fabricate(:pm)
        parser = YAMLParser.new(pm.to_yaml)
        parser.parse!.should == pm
      end
    end
    it 'can be used to create PM from yaml-string' do
      pm = Fabricate(:pm)
      pm_copy = PM.new(pm.to_yaml, YAMLParser)
      pm_copy.should == pm
    end

    context '::split_on_motifs' do
      it 'should be able to get a single PM' do
        pm = Fabricate(:pm)
        YAMLParser.split_on_motifs(pm.to_yaml, PM).should == [ pm ]
      end
    end
  end

  describe YAMLCollectionParser do
    let(:yamled_collection){ Fabricate(:three_elements_collection).to_yaml }
    let(:pm_1){ Fabricate(:pm_1) }
    let(:pm_2){ Fabricate(:pm_2) }
    let(:pm_3){ Fabricate(:pm_3) }

    context '::split_on_motifs' do
      it 'should be able to split yamled collection into PMs' do
        YAMLCollectionParser.split_on_motifs(yamled_collection).should == [pm_1, pm_2, pm_3]
      end
    end
    context '#parse!' do
      it 'should return PMs which were in encoded YAML format' do
        @parser = YAMLCollectionParser.new(yamled_collection)
        @parser.parse!.should == pm_1
        @parser.parse!.should == pm_2
        @parser.parse!.should == pm_3
        expect{ @parser.parse! }.to raise_error
      end
    end
  end
end
