require_relative '../support'
require_relative 'parser'
require_relative '../data_models/collection'
require 'yaml'

module Bioinform
  # YAMLParser can be used to parse hashes returned by #parse method of other parsers:
  # yaml_dump_of_pm = PM.new(...).to_yaml
  # PM.new(yaml_dump_of_pm, YAMLParser)
  class YAMLParser < Parser
    def parse!(input)
      YAML.load(input)
    rescue Psych::SyntaxError
      raise 'parsing error'
    end
  end

  class YAMLCollectionParser < Parser
    def parse!(input)
      @collection = YAML.load(input)
      @collection.container.shift.pm
    rescue Psych::SyntaxError
      raise 'parsing error'
    end
    def rest_input
      !@collection.empty? ? @collection.to_yaml : nil
    end
  end
end
