$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'

def parser_specs(parser_klass, good_cases, bad_cases)
  good_cases.each do |case_description, input_and_result|
    it "should be able to parse #{case_description}" do
      result = parser_klass.new(input_and_result[:input]).parse
      result[:matrix].should == input_and_result[:matrix]
      result[:name].should == input_and_result[:name] if input_and_result.has_key?(:name)
    end
  end
  
  bad_cases.each do |case_description, input|
    it "should fail silently returning {} on parsing #{case_description}" do
      parser_klass.new(input[:input]).parse.should == {}
    end
  end
end