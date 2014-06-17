require 'yaml'
require_relative '../spec_helper'
require_relative '../../lib/bioinform/parsers/yaml_parser'

module Bioinform
  describe YAMLParser do
    context '#parse!' do
      it 'should return PM that was encoded in YAML format' do
        pm = Fabricate(:pm)
        parser = YAMLParser.new
        parser.parse!(pm.to_yaml).should == pm
      end
    end
    it 'can be used to create PM from yaml-string' do
      pm = Fabricate(:pm)
      pm_copy = PM.new(pm.to_yaml, YAMLParser.new)
      pm_copy.should == pm
    end

    context '::split_on_motifs' do
      it 'should be able to get a single PM' do ##################
        pm = Fabricate(:pm)
        CollectionParser.new(YAMLParser.new, pm.to_yaml).split_on_motifs(PM).should == [ pm ]
      end
    end
  end
end
