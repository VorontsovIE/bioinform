require 'spec_helper'
require 'bioinform/cli'

describe Bioinform::CLI do
  describe '::output_filename' do
    it 'should change extension and folder' do
      Bioinform::CLI.output_filename('test.pcm', 'pwm', '.').should == './test.pwm'
      Bioinform::CLI.output_filename('test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      Bioinform::CLI.output_filename('pcm/test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      Bioinform::CLI.output_filename('test.pcm', 'pat', '../pwm_folder').should == '../pwm_folder/test.pat'
    end
  end
end