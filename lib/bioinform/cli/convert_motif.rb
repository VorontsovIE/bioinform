require_relative '../../bioinform'
require 'optparse'

require 'logger'
$logger = Logger.new('convert_motif.log')

module Bioinform
  module CLI
    class ConvertMotif
      
      def arguments
       @arguments ||= []
      end
      def options
        @options ||= {}
      end
      
      def main(argv)
        parse!(argv, filename_format: './{name}.{ext}')
        motif_files = arguments
        motif_files += $stdin.read.shellsplit  unless $stdin.tty?
        if motif_files.empty?
          puts option_parser.help()
          return
        end
        
        output_motifs = []
        motifs = motif_files.map do |filename|
          case options[:model_from]
          when 'pwm'
            PWM.new(File.read(filename))
          when 'pcm'
            PCM.new(File.read(filename))
          when 'ppm'
            PPM.new(File.read(filename))
          end
        end
        
        motifs.each do |motif|
          begin
            case options[:model_to]
            when 'pwm'
              output_motifs << motif.to_pwm
            when 'pcm'
              output_motifs << motif.to_pcm
            when 'ppm'
              output_motifs << motif.to_ppm
            end
          rescue
            $stderr.puts "One can't convert from #{options[:model_from]} data-model to #{options[:model_to]} data-model"
            raise
          end
        end
        puts output_motifs.join("\n\n")
      rescue => e
        $stderr.puts "Error! Conversion wasn't performed"
        $stderr.puts e
        $stderr.puts e.backtrace
      end

      def option_parser
        @option_parser ||= OptionParser.new do |cli|
          banner = <<-BANNER
            Usage:
              convert_motif [options] <motif-files>...
              ls | convert_motif [options]
              
            convert_motif - tool for converting motifs from different input formats
                                                       to different output formats.
            It can change both formatting style and motif models.
            Resulting model is sent to stdout (this can be overriden with --save option).
          BANNER
          
          cli.version = ::Bioinform::VERSION
          cli.summary_indent = ''
          cli.banner = strip_doc(banner)
          cli.separator ""
          cli.separator "Options:"
          cli.on('--parser PARSER', 'Parser for input motif.'){|parser| options[:parser] = parser}
          cli.on('--formatter FORMATTER', 'Formatter for output motif.'){|formatter| options[:formatter] = formatter}
          cli.on('--from MODEL_OF_INPUT', 'Specify motif model of input.',
                                          'It can be overriden by --parser option',
                                          '(when parser implies certain input model)'){|model_from| options[:model_from] = model_from}
          cli.on('--to MODEL_OF_OUTPUT',  'Specify motif model to convert to.',
                                          'It can be overriden by --formatter option',
                                          '(when formatter implies certain output model)'){|model_to| options[:model_to] = model_to}
          cli.on('--algorithm ALGORITHM', 'Conversion algorithm to transform model.'){|conversion_algorithm| options[:conversion_algorithm] = conversion_algorithm}
          cli.on('--save [FILENAME_FORMAT]',  'Save resulting motifs to according files.',
                                              'filename format by default is ' + options[:filename_format],
                                              'one can specify output folder here',
                                              '{name} is a placeholder for motif name',
                                              '{ext} is a placeholder for motif model') {|filename_format| options[:filename_format] = filename_format  if filename_format}
          cli.on('--[no-]force', 'Overwrite existing files.'){|force| options[:force] = force}
          cli.on('--[no-]silent', 'Suppress error messages and notifications.'){|silent| options[:silent] = silent}
        end
      end

      def parse!(argv, default_options = {})
        @options = default_options.dup
        option_parser.parse!(argv)
        @arguments = argv
      end
      
      
      def self.main(argv)
        self.new.main(argv)
      end
      
    end
  end
end
