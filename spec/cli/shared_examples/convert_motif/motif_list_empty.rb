require_relative '../../../spec_helper'
require_relative 'yield_help_string'

shared_examples 'motif list is empty' do
  Given(:motif_list) { [] }
  
  context 'with options' do
    Given(:options) { '--formatter default  --silent' }
    include_examples 'yield help string'
  end
  
  context 'without options' do
    Given(:options){ '' }
    include_examples 'yield help string'
  end
end  
