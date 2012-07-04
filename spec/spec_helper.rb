$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'
module Bioinform
  class Parser
    module Helpers
      def parser_stub(class_name, can_parse, result)
        klass = Class.new(Parser) do
          define_method :can_parse? do can_parse end
          define_method :parse do result end
        end
        #class_levels = class_name.to_s.split('::')
        #class_levels[0..-2].inject(Object){|klass, level| klass.const_get level}.const_set(class_name, class_levels.last)
        Bioinform.const_set(class_name.to_s.split('::').last, klass)
      end
      def parser_subclasses_cleanup          
        Parser.subclasses.each do |klass|
          #class_levels = klass.to_s.split('::')
          #class_levels[0..-2].inject(Object){|klass, level| klass.const_get level}.const_set(class_name, class_levels.last)
          
          Bioinform.send :remove_const, klass.name.split('::').last
        end
        Parser.subclasses.clear
      end
    end
  end
end