shared_examples 'yields motif conversion error' do
  Then { resulting_stderr.should match "One can't convert from #{model_from} data-model to #{model_to} data-model" }
  Then { resulting_stderr.should match "Error! Conversion wasn't performed" }
end
