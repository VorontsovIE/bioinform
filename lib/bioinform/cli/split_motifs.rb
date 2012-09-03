require 'bioinform'
require 'docopt'

module Bioinform
  module CLI
    module SplitMotifs
      
      def self.main(argv)
        doc = <<-DOCOPT
Motif splitter.
It get a file with a set of motifs and splits it into motifs according to their names.

Usage:
  #{__FILE__} [options] <collection-file>
  
Options:
  -h --help                Show this screen.
  -m --data-model MODEL    Data model: PM, PCM, PPM or PWM [default: PM]
  -e --extension EXT       Extension of output files (by default it's based on data model)
  -f --folder FOLDER       Where to save output files [default: .]
        DOCOPT

        options = Docopt::docopt(doc, argv: argv)
        
        folder = options['--folder']
        Dir.mkdir(folder)  unless Dir.exist?(folder)
        
        data_model = Bioinform.const_get(options['--data-model'].upcase)
        extension = options['--extension'] || options['--data-model'].downcase
        
        collection_filename = options['<collection-file>']
        raise "File #{collection_filename} not exist"  unless File.exist? collection_filename
        input = File.read(collection_filename)
        
        data_model.choose_parser(input).split_on_motifs(input, data_model).each do |motif|
          File.open(File.join(folder, "#{motif.name}.#{extension}"), 'w') do |f|
            f.puts motif
          end
        end
      rescue Docopt::Exit => e
        puts e.message
      end
      
    end
  end
end