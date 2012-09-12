require 'bioinform/support'
require 'bioinform/parsers/parser'

module Bioinform
  # TrivialParser can be used to parse hashes returned by #parse method of other parsers:
  # PM.new({matrix:[[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
  # PM.new(StringParser.new("1 2 3 4\n5 6 7 8").parse)
  # StringParser.new("First\n1 2 3 4\n5 6 7 8\nSecond\n0 0 0 0").map{|inp| PM.new(inp, TrivialParser)}
  class TrivialParser < Parser
    def initialize(input)
      @input = input
      @size = input.is_a?(Collection) ? input.size : 1
    end
    def parse!
      raise 'All object already obtained from YAMLParser' if @size.zero?
      result = case input
      when Collection then input.collection.shift.first
      when PM then input
      when OpenStruct then input
      when Hash then OpenStruct.new(input)
      end
      @size -=1
      result
    end
  end
end