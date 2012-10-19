require_relative '../../../spec_helper'

shared_examples 'yield help string' do
  Then { resulting_stdout.should match(/Usage:.*Options:/m) }
end