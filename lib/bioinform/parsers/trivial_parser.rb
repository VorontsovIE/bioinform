require_relative '../support'
require_relative '../parsers/parser'
require 'yaml'

module Bioinform
  # TrivialParser can be used to parse hashes returned by #parse method of other parsers:
  # PM.new({matrix:[[1,2,3,4],[5,6,7,8]], name: 'Name'}, TrivialParser)
  # PM.new(StringParser.new("1 2 3 4\n5 6 7 8").parse)
  # StringParser.new("First\n1 2 3 4\n5 6 7 8\nSecond\n0 0 0 0").map{|inp| PM.new(inp, TrivialParser)}
  class TrivialParser < Parser

    def parse!(input)
      case input
      when OpenStruct then input
      when Hash then OpenStruct.new(input)
      end
    end
  end
end
