require_relative '../../../spec_helper'

shared_examples 'yield help string' do
  Then { expect(resulting_stdout).to match(/Usage:.*Options:/m) }
end
