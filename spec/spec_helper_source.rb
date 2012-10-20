# from minitest (TODO: make use of minitest, not override it)
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
def provide_stdin(input, tty = false, &block)
  orig_stdin = $stdin
  $stdin = StringIO.new(input)
  $stdin.send(:define_singleton_method, :tty?){ tty }  # Simulate that stdin is tty by default
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

def parser_specs(parser_klass, good_cases, bad_cases)
  context '#parse!' do
    good_cases.each do |case_description, input_and_result|
      it "should be able to parse #{case_description}" do
        result = parser_klass.new(input_and_result[:input]).parse
        Bioinform::PM.new(result).should == input_and_result[:result]
      end
    end

    bad_cases.each do |case_description, input|
      it "should raise an exception on parsing #{case_description}" do
        expect{ parser_klass.new(input[:input]).parse! }.to raise_error
      end
    end
  end
end

##############################

def make_file(filename, content)
  File.open(filename, 'w'){|f| f.puts content }
end

def motif_filename(motif, model_type)
  "#{motif.name}.#{model_type}"
end

def make_model_file(motif, model_type)
  make_file(motif_filename(motif, model_type), motif.send(model_type))
end
