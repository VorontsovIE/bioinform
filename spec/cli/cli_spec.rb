require_relative '../spec_helper'
require_relative '../../lib/bioinform/cli'

describe Bioinform::CLI do
  describe '.change_folder_and_extension' do
    it 'should change extension and folder' do
      extend Bioinform::CLI::Helpers
      expect( change_folder_and_extension('test.pcm', 'pwm', '.') ).to eq './test.pwm'
      expect( change_folder_and_extension('test.pcm', 'pat', 'pwm_folder') ).to eq 'pwm_folder/test.pat'
      expect( change_folder_and_extension('pcm/test.pcm', 'pat', 'pwm_folder') ).to eq 'pwm_folder/test.pat'
      expect( change_folder_and_extension('test.pcm', 'pat', '../pwm_folder') ).to eq '../pwm_folder/test.pat'
    end
  end
end
