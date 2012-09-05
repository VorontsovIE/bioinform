require 'spec_helper'
require 'shellwords'
require 'bioinform/cli/pcm2pwm'
require 'fileutils'
require 'stringio'

# from minitest
def capture_io(&block)
  orig_stdout, orig_stderr = $stdout, $stderr
  captured_stdout, captured_stderr = StringIO.new, StringIO.new
  $stdout, $stderr = captured_stdout, captured_stderr
  yield
  return {stdout: captured_stdout.string, stderr: captured_stderr.string}
ensure
  $stdout = orig_stdout
  $stderr = orig_stderr
end

# Method stubs $stdin not STDIN !
def provide_stdin(input, &block)
  orig_stdin = $stdin
  $stdin = StringIO.new(input)
  yield
ensure  
  $stdin = orig_stdin
end

def capture_output(&block)
  capture_io(&block)[:stdout]
end
def capture_stderr(&block)
  capture_io(&block)[:stderr]
end


def run_pcm2pwm(cmd)
  Bioinform::CLI::PCM2PWM.main(cmd.shellsplit)
end
def testdata_filename(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end


describe Bioinform::CLI::PCM2PWM do
  before :each do
    @start_dir = Dir.pwd
    Dir.chdir testdata_filename('.')
  end
  after :each do
    File.delete(testdata_filename('KLF4_f2.pwm'))  if File.exist?(testdata_filename('KLF4_f2.pwm'))
    File.delete(testdata_filename('SP1_f1.pwm'))  if File.exist?(testdata_filename('SP1_f1.pwm'))
    File.delete(testdata_filename('KLF4_f2.pat'))  if File.exist?(testdata_filename('KLF4_f2.pat'))
    FileUtils.rm_rf(testdata_filename('pwm_folder'))  if Dir.exist?(testdata_filename('pwm_folder'))
    Dir.chdir(@start_dir)
  end
  
  it 'should transform single PCM to PWM' do
    run_pcm2pwm("#{testdata_filename('KLF4_f2.pcm')}")
    File.exist?(testdata_filename('KLF4_f2.pwm')).should be_true
    File.read(testdata_filename('KLF4_f2.pwm')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
  end
  
  it 'should transform multiple PCMs to PWMs' do
    run_pcm2pwm("#{testdata_filename('KLF4_f2.pcm')} #{testdata_filename('SP1_f1.pcm')}")
    
    File.exist?(testdata_filename('KLF4_f2.pwm')).should be_true
    File.read(testdata_filename('KLF4_f2.pwm')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
    
    File.exist?(testdata_filename('SP1_f1.pwm')).should be_true
    File.read(testdata_filename('SP1_f1.pwm')).should == File.read(testdata_filename('SP1_f1.pwm.result'))
  end
  
  it 'should transform extension to specified with --extension option' do
    run_pcm2pwm("#{testdata_filename('KLF4_f2.pcm')} --extension=pat")
    File.exist?(testdata_filename('KLF4_f2.pat')).should be_true
    File.read(testdata_filename('KLF4_f2.pat')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
  end
  
  it 'should save PWMs into folder specified with --folder option when folder exists' do
    Dir.mkdir(testdata_filename('pwm_folder'))  unless Dir.exist?(testdata_filename('pwm_folder'))
    run_pcm2pwm("#{testdata_filename('KLF4_f2.pcm')} --folder=#{testdata_filename('pwm_folder')}")
    File.exist?(testdata_filename('pwm_folder/KLF4_f2.pwm')).should be_true
    File.read(testdata_filename('pwm_folder/KLF4_f2.pwm')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
  end
  it 'should save PWMs into folder specified with --folder option' do
    FileUtils.rm_rf(testdata_filename('pwm_folder'))  if Dir.exist?(testdata_filename('pwm_folder'))
    run_pcm2pwm("#{testdata_filename('KLF4_f2.pcm')} --folder=#{testdata_filename('pwm_folder')}")
    File.exist?(testdata_filename('pwm_folder/KLF4_f2.pwm')).should be_true
    File.read(testdata_filename('pwm_folder/KLF4_f2.pwm')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
  end
  
  it 'should process PCMs with names obtained from STDIN' do
    provide_stdin('KLF4_f2.pcm SP1_f1.pcm') { run_pcm2pwm('') }
    File.exist?(testdata_filename('KLF4_f2.pwm')).should be_true
    File.read(testdata_filename('KLF4_f2.pwm')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
    
    File.exist?(testdata_filename('SP1_f1.pwm')).should be_true
    File.read(testdata_filename('SP1_f1.pwm')).should == File.read(testdata_filename('SP1_f1.pwm.result'))
  end
  
  it 'should process PCMs with names obtained from STDIN when there are some options' do
    provide_stdin('KLF4_f2.pcm') { run_pcm2pwm('-e pat') }
    File.exist?(testdata_filename('KLF4_f2.pat')).should be_true
    File.read(testdata_filename('KLF4_f2.pat')).should == File.read(testdata_filename('KLF4_f2.pwm.result'))
  end

end