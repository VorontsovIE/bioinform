require 'shellwords'
require_relative '../spec_helper'
require 'bioinform/cli/pcm2pwm'


def run_pcm2pwm(cmd)
  Bioinform::CLI::PCM2PWM.main(cmd.shellsplit)
end

describe Bioinform::CLI::PCM2PWM do
  before :each do
    @start_dir = Dir.pwd
    Dir.chdir File.join(File.dirname(__FILE__), 'data', 'pcm2pwm')
  end
  after :each do
    File.delete('KLF4_f2.pwm')  if File.exist?('KLF4_f2.pwm')
    File.delete('SP1_f1.pwm')  if File.exist?('SP1_f1.pwm')
    File.delete('KLF4_f2.pat')  if File.exist?('KLF4_f2.pat')
    File.delete('KLF4 f2 spaced name.pwm')  if File.exist?('KLF4 f2 spaced name.pwm')
    FileUtils.rm_rf('pwm_folder')  if Dir.exist?('pwm_folder')
    Dir.chdir(@start_dir)
  end

  it 'should transform single PCM to PWM' do
    run_pcm2pwm('KLF4_f2.pcm')
    expect(File.exist?('KLF4_f2.pwm')).to be_truthy
    expect(File.read('KLF4_f2.pwm')).to eq File.read('KLF4_f2.pwm.result')
  end

  it 'should transform multiple PCMs to PWMs' do
    run_pcm2pwm('KLF4_f2.pcm SP1_f1.pcm')

    expect(File.exist?('KLF4_f2.pwm')).to be_truthy
    expect(File.read('KLF4_f2.pwm')).to eq File.read('KLF4_f2.pwm.result')

    expect(File.exist?('SP1_f1.pwm')).to be_truthy
    expect(File.read('SP1_f1.pwm')).to eq File.read('SP1_f1.pwm.result')
  end

  it 'should transform extension to specified with --extension option' do
    run_pcm2pwm('KLF4_f2.pcm --extension=pat')
    expect(File.exist?('KLF4_f2.pat')).to be_truthy
    expect(File.read('KLF4_f2.pat')).to eq File.read('KLF4_f2.pwm.result')
  end

  it 'should save PWMs into folder specified with --folder option when folder exists' do
    Dir.mkdir('pwm_folder')  unless Dir.exist?('pwm_folder')
    run_pcm2pwm('KLF4_f2.pcm --folder=pwm_folder')
    expect(File.exist?('pwm_folder/KLF4_f2.pwm')).to be_truthy
    expect(File.read('pwm_folder/KLF4_f2.pwm')).to eq File.read('KLF4_f2.pwm.result')
  end
  it 'should save PWMs into folder specified with --folder option' do
    FileUtils.rm_rf('pwm_folder')  if Dir.exist?('pwm_folder')
    run_pcm2pwm('KLF4_f2.pcm --folder=pwm_folder')
    expect(File.exist?('pwm_folder/KLF4_f2.pwm')).to be_truthy
    expect(File.read('pwm_folder/KLF4_f2.pwm')).to eq File.read('KLF4_f2.pwm.result')
  end

  it 'should process PCMs with names obtained from STDIN' do
    provide_stdin('KLF4_f2.pcm SP1_f1.pcm') { run_pcm2pwm('') }
    expect(File.exist?('KLF4_f2.pwm')).to be_truthy
    expect(File.read('KLF4_f2.pwm')).to eq File.read('KLF4_f2.pwm.result')

    expect(File.exist?('SP1_f1.pwm')).to be_truthy
    expect(File.read('SP1_f1.pwm')).to eq File.read('SP1_f1.pwm.result')
  end

  it 'should process PCMs with names obtained from STDIN when there are some options' do
    provide_stdin('KLF4_f2.pcm') { run_pcm2pwm('-e pat') }
    expect(File.exist?('KLF4_f2.pat')).to be_truthy
    expect(File.read('KLF4_f2.pat')).to eq File.read('KLF4_f2.pwm.result')
  end

  it 'should process PCMs having filename with spaces' do
    run_pcm2pwm('"KLF4 f2 spaced name.pcm"')
    expect(File.exist?('KLF4 f2 spaced name.pwm')).to be_truthy
    expect(File.read('KLF4 f2 spaced name.pwm')).to eq File.read('KLF4_f2.pwm.result')
  end
end
