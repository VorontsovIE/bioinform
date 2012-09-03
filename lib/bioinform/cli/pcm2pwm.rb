require 'bioinform'
require 'docopt'
require 'shellwords'

module Bioinform
  module CLI
    module PCM2PWM
      def self.main(argv)
        doc = <<-DOCOPT
PCM to PWM converter.
It transforms files with PCMs into files with PWMs. Folder for resulting files to save files can be specified. Resulting PWM files have the same name as original file but have another extension (.pwm by default).
When filelist is empty, it's obtained from STDIN. One can use it: `ls -b pcm_folder/*.pcm | pcm2pwm` (ls -b option escape spaces in filenames)

Usage:
  #{__FILE__} [options] [<pcm-files>...]
  
Options:
  -h --help           Show this screen.
  -e --extension EXT  Extension of output files [default: pwm]
  -f --folder FOLDER  Where to save output files [default: .]
        DOCOPT

        options = Docopt::docopt(doc, argv: argv)
        
        if options['<pcm-files>'].empty?
          filelist = $stdin.read.shellsplit
        else
          filelist = options['<pcm-files>']
        end
        
        folder = options['--folder']
        Dir.mkdir(folder)  unless Dir.exist?(folder)
        
        filelist.each do |pcm_filename|
          pwm = Bioinform::PCM.new( File.read(pcm_filename) ).to_pwm
          File.open(Bioinform::CLI.output_filename(pcm_filename, options['--extension'], folder), 'w') do |f|
            f.puts pwm
          end
        end
        
      rescue Docopt::Exit => e
        puts e.message
      end
      
    end
  end
end