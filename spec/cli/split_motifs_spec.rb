require_relative '../spec_helper'
require_relative '../../lib/bioinform/cli/split_motifs'

def run_split_motifs(cmd)
  Bioinform::CLI::SplitMotifs.main(cmd.shellsplit)
end

describe Bioinform::CLI::SplitMotifs do
  before :each do
    @start_dir = Dir.pwd
    @motifs_in_collection = %w[KLF4_f2 SP1_f1 GABPA_f1]
    Dir.chdir File.join(File.dirname(__FILE__), 'data', 'split_motifs')
  end
  after :each do
    @motifs_in_collection.each do |motif_name|
      File.delete("#{motif_name}.mat")  if File.exist?("#{motif_name}.mat")
      File.delete("#{motif_name}.pwm")  if File.exist?("#{motif_name}.pwm")
      File.delete("#{motif_name}.pat")  if File.exist?("#{motif_name}.pat")
    end
    FileUtils.rm_rf('result_folder')  if Dir.exist?('result_folder')
    Dir.chdir(@start_dir)
  end
  it 'splits plain text into separate files' do
    run_split_motifs('plain_collection.txt')
    @motifs_in_collection.each do |motif_name|
      File.exist?("#{motif_name}.mat").should be_truthy
      File.read("#{motif_name}.mat") == File.read("#{motif_name}.mat.result")
    end
  end
  it 'create files with specified extension' do
    run_split_motifs('plain_collection.txt -e pwm')
    @motifs_in_collection.each do |motif_name|
      File.exist?("#{motif_name}.pwm").should be_truthy
      File.read("#{motif_name}.pwm") == File.read("#{motif_name}.mat.result")
    end
  end
  
  context 'when specified folder exist' do
    before :each do
      Dir.mkdir('result_folder')  unless Dir.exist?('result_folder')
    end
    it 'create files in specified folder' do
      run_split_motifs('plain_collection.txt -f result_folder')
      @motifs_in_collection.each do |motif_name|
        File.exist?(File.join('result_folder', "#{motif_name}.mat")).should be_truthy
        File.read(File.join('result_folder', "#{motif_name}.mat")) == File.read("#{motif_name}.mat.result")
      end
    end
  end
  context 'when specified folder not exist' do
    before :each do
      FileUtils.rm_rf('result_folder')  if Dir.exist?('result_folder')
    end
    it 'create files in specified folder' do
      run_split_motifs('plain_collection.txt -f result_folder')
      @motifs_in_collection.each do |motif_name|
        File.exist?(File.join('result_folder', "#{motif_name}.mat")).should be_truthy
        File.read(File.join('result_folder', "#{motif_name}.mat")) == File.read("#{motif_name}.mat.result")
      end
    end
  end
  
  it 'splits motifs from Collections (yamled Bioinform::Collection instances) with appropriate extension' do
    run_split_motifs('collection.yaml')
    @motifs_in_collection.each do |motif_name|
      File.exist?("#{motif_name}.pwm").should be_truthy
      File.read("#{motif_name}.pwm") == File.read("#{motif_name}.mat.result")
    end
  end
  it 'splits motifs from Collections with specified extension' do
    run_split_motifs('collection.yaml -e pat')
    @motifs_in_collection.each do |motif_name|
      File.exist?("#{motif_name}.pat").should be_truthy
      File.read("#{motif_name}.pat") == File.read("#{motif_name}.mat.result")
    end
  end
end
