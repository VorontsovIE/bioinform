require_relative '../spec_helper'
require_relative '../../lib/bioinform/cli'

describe Bioinform::CLI do
  describe '.change_folder_and_extension' do
    it 'should change extension and folder' do
      extend Bioinform::CLI::Helpers
      change_folder_and_extension('test.pcm', 'pwm', '.').should == './test.pwm'
      change_folder_and_extension('test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      change_folder_and_extension('pcm/test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      change_folder_and_extension('test.pcm', 'pat', '../pwm_folder').should == '../pwm_folder/test.pat'
    end
  end
end