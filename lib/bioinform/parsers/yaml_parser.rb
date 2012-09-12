require 'bioinform/support'
require 'bioinform/parsers/parser'

module Bioinform
  # TrivialParser can be used to parse hashes returned by #parse method of other parsers:
  # yaml_dump_of_pm = PM.new(...).to_yaml
  # PM.new(yaml_dump_of_pm, YAMLParser)
  class YAMLParser < Parser
    def initialize(input)
      @input = YAML.load(input)
    end
    def parse!
      raise 'All object already obtained from YAMLParser' if @finished
      case input
      when PM 
        @finished = true
        input
      when Collection
        result = input.collection.shift.first
        @finished = input.collection.empty?
        result
      end
    end
  end
end