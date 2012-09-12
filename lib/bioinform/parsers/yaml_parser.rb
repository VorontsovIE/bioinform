require 'bioinform/support'
require 'bioinform/parsers/parser'

module Bioinform
  # YAMLParser can be used to parse hashes returned by #parse method of other parsers:
  # yaml_dump_of_pm = PM.new(...).to_yaml
  # PM.new(yaml_dump_of_pm, YAMLParser)
  class YAMLParser < Parser
    def initialize(input)
      @input = YAML.load(input)
    end
    def parse!
      input
    end
  end
  
  class YAMLCollectionParser < Parser
    include MultipleMotifsParser
    def initialize(input)
      @input = YAML.load(input)
    end
    def parse!
      input.collection.shift.first
    end
  end
end