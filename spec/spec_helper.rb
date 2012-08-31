$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'

def parser_specs(parser_klass, good_cases, bad_cases)
  context '#parse!' do
    good_cases.each do |case_description, input_and_result|
      it "should be able to parse #{case_description}" do
        result = parser_klass.new(input_and_result[:input]).parse
        result[:matrix].should == input_and_result[:matrix]
        if input_and_result.has_key?(:name)
          result[:name].should == input_and_result[:name]
        else 
          result[:name].should be_nil
        end
      end
    end

    bad_cases.each do |case_description, input|
      it "should raise an exception on parsing #{case_description}" do
        expect{ parser_klass.new(input[:input]).parse! }.to raise_error
      end
    end
  end
end