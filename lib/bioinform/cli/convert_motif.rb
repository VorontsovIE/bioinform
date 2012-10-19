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
        $logger.info argv
        parse!(argv, filename_format: './{name}.{ext}')
        motif_files = arguments
        motif_files += $stdin.read.shellsplit  unless $stdin.tty?
        if motif_files.empty?
          puts option_parser.help()
          return
        end
        
        motif_files.each do |filename|
          $logger.info filename
          $logger.info File.read(filename)
          motif = PCM.new(File.read(filename))
          

          case options[:to_model]
          when 'pwm'
            puts motif.to_pwm
          #when 'pñm'
            #puts motif.to_pcm
          when 'ppm'
            puts motif.to_ppm
          end

        end

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
          
          cli.summary_indent = ''
          cli.banner = strip_doc(banner)
          cli.separator ""
          cli.separator "Options:"
          cli.on('--parser PARSER', 'Parser for input motif.'){|parser| options[:parser] = parser}
          cli.on('--formatter FORMATTER', 'Formatter for output motif.'){|formatter| options[:formatter] = formatter}
          cli.on('--from MODEL_OF_INPUT', 'Specify motif model of input.',
                                          'It can be overriden by --parser option',
                                          '(when parser implies certain input model)'){|from_model| options[:from_model] = from_model}
          cli.on('--to MODEL_OF_OUTPUT',  'Specify motif model to convert to.',
                                          'It can be overriden by --formatter option',
                                          '(when formatter implies certain output model)'){|to_model| options[:to_model] = to_model}
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