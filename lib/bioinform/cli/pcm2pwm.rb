require_relative '../../bioinform'
require 'optparse'
require 'shellwords'

module Bioinform
  module CLI
    module PCM2PWM
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        options = {folder: '.', extension: 'pwm'}
        opt_parser = OptionParser.new do |opts|
          opts.banner = "PCM to PWM converter.\n" +
                        "It transforms files with PCMs into files with PWMs.\n" +
                        "Folder for resulting files to save files can be specified.\n" +
                        "Resulting PWM files have the same name as original file but have another extension (.pwm by default).\n" +
                        "When filelist is empty, it's obtained from STDIN.\n" +
                        "One can use it: `ls -b pcm_folder/*.pcm | pcm2pwm` (ls -b option escape spaces in filenames)\n" +
                        "\n" +
                        "Usage:\n" +
                        "  pcm2pwm [options] [<pcm-files>...]"
          opts.version = ::Bioinform::VERSION
          opts.on('-e', '--extension EXT', 'Extension of output files [default: pwm]') do |v|
            options[:extension] = v
          end
          opts.on('-f', '--folder FOLDER', 'Where to save output files') do |v|
            options[:folder] = v
          end
        end

        opt_parser.parse!(argv)
        pcm_files = argv
        folder = options[:folder]
        extension = options[:extension]

        Dir.mkdir(folder)  unless Dir.exist?(folder)
        filelist = (pcm_files.empty?)  ?  $stdin.read.shellsplit  :  pcm_files

        converter = ConversionAlgorithms::PCM2PWMConverter.new()

        filelist.each do |filename|
          input = File.read(filename)
          motif_data = MatrixParser.new.parse(input)
          pcm = MotifModel::PCM.new(motif_data[:matrix]).named(motif_data[:name])
          pwm = converter.convert(pcm)
          File.open(change_folder_and_extension(filename, extension, folder), 'w') do |f|
            f.puts pwm
          end
        end
      end

    end
  end
end
