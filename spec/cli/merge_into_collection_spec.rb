require 'shellwords'
require 'yaml'
require_relative '../spec_helper'
require_relative '../../lib/bioinform/cli/merge_into_collection'
require_relative '../../lib/bioinform/data_models/collection'


def run_merge_into_collection(cmd)
  Bioinform::CLI::MergeIntoCollection.main(cmd.shellsplit)
end

describe Bioinform::CLI::MergeIntoCollection do
  before :each do
    @start_dir = Dir.pwd
    Dir.chdir File.join(File.dirname(__FILE__), 'data', 'merge_into_collection')
  end
  after :each do
    File.delete('collection.yaml')  if File.exist?('collection.yaml')
    File.delete('collection.txt')  if File.exist?('collection.txt')
    File.delete('my_collection.yaml')  if File.exist?('my_collection.yaml')
    File.delete('my_collection.txt')  if File.exist?('my_collection.txt')
    File.delete('result.out')  if File.exist?('result.out')
    Dir.chdir(@start_dir)
  end

  context 'without --plain option' do
    context 'when name not specified' do
      it 'collects motifs into file collection.yaml' do
        run_merge_into_collection('GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('collection.yaml').should be_true
        YAML.load(File.read('collection.yaml')).should == YAML.load(File.read('collection.yaml.result'))
      end
    end
    
    context 'when name specified' do
      it 'collects motifs into file <collection name>.yaml' do
        run_merge_into_collection('--name my_collection GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('my_collection.yaml').should be_true
        YAML.load(File.read('my_collection.yaml')).should == YAML.load(File.read('collection.yaml.result')).set_parameters(name: 'my_collection')
      end
    end
    
    context 'with --data-model option' do
      it 'treat motifs as specified data model' do
        run_merge_into_collection('--data-model pwm GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('collection.yaml').should be_true
        YAML.load(File.read('collection.yaml')).should == YAML.load(File.read('collection_pwm.yaml.result'))
      end
    end
  end
  
  context 'with --plain option' do
    context 'when name not specified' do
      it 'should collect motifs into file collection.txt in plain-text format' do
        run_merge_into_collection('--plain GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('collection.txt').should be_true
        YAML.load(File.read('collection.txt')).should == YAML.load(File.read('collection.txt.result'))
      end
    end
    
    context 'when name specified' do
      it 'should collect motifs into file <collection name>.txt in plain-text format' do
        run_merge_into_collection('--name my_collection --plain GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('my_collection.txt').should be_true
        YAML.load(File.read('my_collection.txt')).should == YAML.load(File.read('collection.txt.result'))
      end
    end

    context 'with --data-model option' do
      it 'generate usual txt file' do
        run_merge_into_collection('--data-model pwm --plain GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
        File.exist?('collection.txt').should be_true
        YAML.load(File.read('collection.txt')).should == YAML.load(File.read('collection.txt.result'))
      end
    end
  end

  context 'when --output-file specified' do
    it 'collects motifs into specified file' do
      run_merge_into_collection('--output-file result.out GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm')
      File.exist?('result.out').should be_true
      YAML.load(File.read('result.out')).should == YAML.load(File.read('collection.yaml.result'))
    end
  end
  
  context 'when filelist is empty' do
    it 'takes filelist from stdin' do
      provide_stdin('GABPA_f1.pwm KLF4_f2.pwm SP1_f1.pwm'){ run_merge_into_collection('') }
      File.exist?('collection.yaml').should be_true
      YAML.load(File.read('collection.yaml')).should == YAML.load(File.read('collection.yaml.result'))
    end
  end
  context 'when filelist contain folder name' do
    it 'takes filelist as files from folder' do
      run_merge_into_collection('pwm_folder')
      File.exist?('collection.yaml').should be_true
      YAML.load(File.read('collection.yaml')).should == YAML.load(File.read('collection.yaml.result'))
    end
  end
end