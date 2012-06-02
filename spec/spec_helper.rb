$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'test/unit'
require 'rspec'

class PM
  class Parser
    module Helpers
      def parser_stub(class_name, can_parse, result)
        klass = Class.new(PM::Parser) do
          define_method :can_parse? do can_parse end
          define_method :parse do result end
        end
        Object.const_set(class_name, klass)
      end
      def parser_subclasses_cleanup
        PM::Parser.subclasses.each{|klass| Object.send :remove_const, klass.name}
        PM::Parser.subclasses.clear
      end
    end
  end
end
