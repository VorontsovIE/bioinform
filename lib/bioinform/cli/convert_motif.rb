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
          input = File.read(filename)
          motif_info = Parser.choose(input).parse(input)
          case options[:model_from]
          when 'pwm'
            MotifModel::PWM.new(motif_info.matrix).named(motif_info.name)
          when 'pcm'
            MotifModel::PCM.new(motif_info.matrix).named(motif_info.name)
          when 'ppm'
            MotifModel::PPM.new(motif_info.matrix).named(motif_info.name)
          else
            raise "Unknown value of model-from parameter: `#{options[:model_from]}`"
          end
        end
        pcm2pwm_converter = ConversionAlgorithms::PCM2PWMConverter.new(pseudocount: :log, background: Background::Uniform)
        pcm2ppm_converter = ConversionAlgorithms::PCM2PPMConverter.new
        ppm2pcm_converter = ConversionAlgorithms::PPM2PCMConverter.new(count: 100)
        motifs.each do |motif|
          begin
            case options[:model_to]
            when 'pwm'
              if MotifModel.acts_as_pcm?(motif)
                output_motifs << pcm2pwm_converter.convert(motif)
              elsif MotifModel.acts_as_ppm?(motif)
                output_motifs << pcm2pwm_converter.convert(ppm2pcm_converter.convert(motif))
              elsif MotifModel.acts_as_pwm?(motif)
                output_motifs << motif
              else
                raise "Can't be here"
              end
            when 'pcm'
              if MotifModel.acts_as_pcm?(motif)
                output_motifs << motif
              elsif MotifModel.acts_as_ppm?(motif)
                output_motifs << ppm2pcm_converter.convert(motif)
              elsif MotifModel.acts_as_pwm?(motif)
                raise 'Not yet implemented'
              else
                raise "Can't be here"
              end
            when 'ppm'
              if MotifModel.acts_as_pcm?(motif)
                output_motifs << pcm2ppm_converter.convert(motif)
              elsif MotifModel.acts_as_ppm?(motif)
                output_motifs << motif
              elsif MotifModel.acts_as_pwm?(motif)
                raise 'Not yet implemented'
              else
                raise "Can't be here"
              end
            else
              raise "Unknown value of model-to parameter: `#{options[:model_to]}`"
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
