require_relative 'parser'
require_relative 'matrix_parser'

module Bioinform
  class MatrixParser
    class TemporaryWrapper
      attr_reader :input
      include Bioinform::Parser::ClassMethods
      include Bioinform::Parser::SingleMotifParser::ClassMethods
      def initialize(parser)
        @parser, input = parser, input
      end
      def parse
        @parser.parse(@input)
      end
      def parse!
        @parser.parse!(@input)
      end
      def new(input)
        @input = input
        self
      end
    end

    def wrapper
      TemporaryWrapper.new(self)
    end
  end
end
