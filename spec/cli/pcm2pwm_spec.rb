require 'spec_helper'
require 'bioinform/cli/pcm2pwm'

describe Bioinform::CLI::PCM2PWM do
  describe '#output_filename' do
    it 'should change extension and folder' do
      Bioinform::CLI::PCM2PWM.output_filename('test.pcm', 'pwm', '.').should == './test.pwm'
      Bioinform::CLI::PCM2PWM.output_filename('test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      Bioinform::CLI::PCM2PWM.output_filename('pcm/test.pcm', 'pat', 'pwm_folder').should == 'pwm_folder/test.pat'
      Bioinform::CLI::PCM2PWM.output_filename('test.pcm', 'pat', '../pwm_folder').should == '../pwm_folder/test.pat'
    end
  end
end