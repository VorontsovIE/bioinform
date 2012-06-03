require 'spec_helper'
require 'bioinform/support/curry_except_self'

describe Proc do
  describe '#curry_except_self' do
    it 'should return proc'
    it 'should behave like a proc where all arguments except first are curried'
  end
end