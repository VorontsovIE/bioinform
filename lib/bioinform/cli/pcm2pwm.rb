require_relative '../../bioinform'
require 'docopt'
require 'shellwords'

module Bioinform
  module CLI  
    module PCM2PWM
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        doc = <<-DOCOPT
          PCM to PWM converter.
          It transforms files with PCMs into files with PWMs. Folder for resulting files to save files can be specified. Resulting PWM files have the same name as original file but have another extension (.pwm by default).
          When filelist is empty, it's obtained from STDIN. One can use it: `ls -b pcm_folder/*.pcm | pcm2pwm` (ls -b option escape spaces in filenames)

          Usage:
            pcm2pwm [options] [<pcm-files>...]

          Options:
            -h --help           Show this screen.
            -e --extension EXT  Extension of output files [default: pwm]
            -f --folder FOLDER  Where to save output files [default: .]
        DOCOPT

        doc.gsub!(/^#{doc[/\A +/]}/,'')
        options = Docopt::docopt(doc, argv: argv)

        pcm_files = options['<pcm-files>']
        folder = options['--folder']
        extension = options['--extension']

        Dir.mkdir(folder)  unless Dir.exist?(folder)
        filelist = (pcm_files.empty?)  ?  $stdin.read.shellsplit  :  pcm_files

        filelist.each do |filename|
          pwm = Bioinform::PCM.new( File.read(filename) ).to_pwm
          File.open(change_folder_and_extension(filename, extension, folder), 'w') do |f|
            f.puts pwm
          end
        end

      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end
