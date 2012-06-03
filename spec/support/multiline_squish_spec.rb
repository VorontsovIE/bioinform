require 'spec_helper'
require 'bioinform/support/multiline_squish'

describe String do
  describe '#multiline_squish' do
    it 'should replace multiple spaces with one space'
    it 'should replace tabs with a space'
    it 'should replace \r\n with \n'
    it 'should preserve rows pagination'
  end
end