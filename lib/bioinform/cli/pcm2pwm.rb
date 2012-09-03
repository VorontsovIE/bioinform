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
When filelist is empty, it's obtained from STDIN. One can use it: `ls -b *.pcm | pcm2pwm` (ls -b option escape spaces in filenames)

Usage:
  #{__FILE__} [options] [<pcm-files>...]
  
Options:
  -h --help           Show this screen.
  -e --extension EXT  Set extension of output files [default: pwm]
  -f --folder FOLDER  Where to save output files [default: .]
        DOCOPT

        options = Docopt::docopt(doc, argv: argv)
        
        if options['<pcm-files>'].empty?
          filelist = $stdin.read.shellsplit
        else
          filelist = options['pcm-files']
        end
        
        filelist.each do |filename|
          output_filename = File.join(options['--folder'], File.basename(filename, File.extname(filename)) + ".#{options['--extension']}")
          pwm = Bioinform::PCM.new( File.read(filename) ).to_pwm
          File.open(output_filename, 'w'){|f| f.puts pwm}
        end
        
      rescue Docopt::Exit => e
        puts e.message
      end
      
    end
  end
end