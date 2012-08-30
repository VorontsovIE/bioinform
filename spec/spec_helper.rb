$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'

def parser_specs(parser_klass, good_cases, bad_cases)
  context '#parse' do
    good_cases.each do |case_description, input_and_result|
      it "should be able to parse #{case_description}" do
        result = parser_klass.new(input_and_result[:input]).parse
        result[:matrix].should == input_and_result[:matrix]
        result[:name].should == input_and_result[:name] if input_and_result.has_key?(:name)
      end
      it 'should give the same result as #parse!' do
        parser_klass.new(input_and_result[:input]).parse.should == parser_klass.new(input_and_result[:input]).parse!
      end
    end
    bad_cases.each do |case_description, input|
      it "should fail silently returning {} on parsing #{case_description}" do
        parser_klass.new(input[:input]).parse.should be_nil
      end
    end
  end
  context '#parse!' do
    bad_cases.each do |case_description, input|
      it "should raise an exception on parsing #{case_description}" do
        expect{ parser_klass.new(input[:input]).parse! }.to raise_error
      end
    end
  end
end