shared_examples 'yields motif conversion error' do
  Then { expect(resulting_stderr).to match "One can't convert from #{model_from} data-model to #{model_to} data-model" }
  Then { expect(resulting_stderr).to match "Error! Conversion wasn't performed" }
end
