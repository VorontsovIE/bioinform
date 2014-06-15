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
            split_motifs [options] <collection-file>

          Options:
            -h --help                Show this screen.
            -e --extension EXT       Extension of output files
            -f --folder FOLDER       Where to save output files [default: .]
        DOCOPT

        doc.gsub!(/^#{doc[/\A +/]}/,'')
        options = Docopt::docopt(doc, argv: argv)

        folder = options['--folder']
        extension = options['--extension']
        collection_filename = options['<collection-file>']

        Dir.mkdir(folder)  unless Dir.exist?(folder)
        raise "File #{collection_filename} not exist"  unless File.exist? collection_filename

        input = File.read(collection_filename)
        coll = Parser.split_on_motifs(input)

        coll.each do |motif|
          if motif.is_a?(PM) && motif.class != PM
            File.open(set_folder(folder, set_extension(motif.name, extension || motif.class.name.gsub(/^.*::/,'').downcase)), 'w'){|f| f.puts motif}
          else
            motif = PM.new(motif)
            File.open(set_folder(folder, set_extension(motif.name, extension || 'mat')), 'w'){|f| f.puts motif}
          end
        end
      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end
