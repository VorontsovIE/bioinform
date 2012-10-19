require 'shellwords'
require_relative '../spec_helper'
require_relative '../../lib/bioinform/cli/convert_motif'
require_relative 'shared_examples/convert_motif/single_motif_specified'
require_relative 'shared_examples/convert_motif/several_motifs_specified'
require_relative 'shared_examples/convert_motif/motif_list_empty'

def make_option_list(options = {})
  result = []
  result << '--from' << options[:model_from]  if options[:model_from]
  result << '--to' << options[:model_to]  if options[:model_to]
  result << '--parser' << options[:parser]  if options[:parser]
  result << '--formatter' << options[:formatter]  if options[:formatter]
  result << (options[:silent] ? '--silent' : '--no-silent')  if options.has_key?(:silent)
  result << (options[:force] ? '--force' : '--no-force')  if options.has_key?(:force)
  result << '--save' << options[:filename_format]  if options[:filename_format]
  result << '--algorithm' << options[:algorithm]  if options[:algorithm]
  result
end


shared_context 'most common options' do
  Given(:parser) { 'plain' }
  Given(:formatter) { 'plain' }
  Given(:silent) { true }
  Given(:force) { false }
  Given(:filename_format) { nil }
  Given(:algorithm) { nil }
end

shared_context 'completely specified option list' do
  Given(:options) {
    make_option_list( model_from: model_from,  model_to: model_to,
                      parser: parser,  formatter: formatter,
                      silent: silent,  force: force,
                      filename_format: filename_format,
                      algorithm: algorithm ).shelljoin 
  }
end

shared_context 'input filenames are motif_name.motif_type' do
  Given(:input_filenames) { motif_list.map{|motif| motif_filename(motif, model_from) }.shelljoin }
end

##################################

describe Bioinform::CLI::ConvertMotif do
  Given(:resulting_stdout) { resulting_io[:stdout] }
  Given(:resulting_stderr) { resulting_io[:stderr] }
  
  Given(:command) { options.shellsplit + arguments.shellsplit }
  
  Given(:sp1_f1){ Fabricate(:SP1_f1_plain_text) }
  Given(:klf4_f2){ Fabricate(:KLF4_f2_plain_text) }
  
########################################################
  
  context 'when program not piped' do
    Given(:arguments) { input_filenames }
    Given(:resulting_io) {
      capture_io{
        FakeFS do
          Bioinform::CLI::ConvertMotif.main(command)
        end
      }
    }
    include_context 'input filenames are motif_name.motif_type'
    
    context 'with most options specified' do
      include_context 'completely specified option list'
      include_context 'most common options'      

      include_examples 'single motif specified'
    end
    
    
    include_examples 'motif list is empty'
    
#    include_examples 'several motifs specified'
  end
  
########################################################

  context 'when program is piped' do
#    include_context 'completely specified option list'
#    include_context 'most common options'
    include_context 'input filenames are motif_name.motif_type'

    Given(:tty){ false }
    Given(:stdin_data) { input_filenames }
    Given(:arguments) { '' }
    Given(:resulting_io) {
      capture_io{
        provide_stdin(stdin_data, tty) {
          Bioinform::CLI::ConvertMotif.main(command)
        }
      }
    }

    include_examples 'motif list is empty'
#    include_examples 'single motif specified'
#    include_examples 'several motifs specified'
  end
end