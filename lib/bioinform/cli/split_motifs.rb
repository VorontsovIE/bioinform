require_relative '../../bioinform'
require 'docopt'

module Bioinform
  module CLI
    module SplitMotifs
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        doc = <<-DOCOPT
          Motif splitter.
          It get a file with a set of motifs and splits it into motifs according to their names.

          Usage:
            #{__FILE__} [options] <collection-file>

          Options:
            -h --help                Show this screen.
            -e --extension EXT       Extension of output files [default: mat]
            -f --folder FOLDER       Where to save output files [default: .]
        DOCOPT

        doc.gsub!(/^#{doc[/\A +/]}/,'')
        options = Docopt::docopt(doc, argv: argv)

        folder = options['--folder']
        extension = options['--extension']
        collection_filename = options['<collection-file>']

        Dir.mkdir(folder)  unless Dir.exist?(folder)
        raise "File #{collection_filename} not exist"  unless File.exist? collection_filename

        PM.split_on_motifs(File.read(collection_filename)).each do |motif|
          File.open(set_folder(folder, set_extension(motif.name, extension)), 'w'){|f| f.puts motif}
        end
      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end