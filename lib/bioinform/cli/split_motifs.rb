require_relative '../../bioinform'
require 'optparse'

module Bioinform
  module CLI
    module SplitMotifs
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        options = {folder: '.'}
        opt_parser = OptionParser.new do |opts|
          opts.version = ::Bioinform::VERSION
          opts.banner = "Motif splitter.\n" +
                        "It gets a file with a set of motifs and splits it into motifs according to their names.\n" +
                        "\n" +
                        "Usage:\n" +
                        "  split_motifs [options] <collection-file>"
          opts.on('-e', '--extension EXT', 'Extension of output files') do |v|
            options[:extension] = v
          end
          opts.on('-f', '--folder FOLDER', 'Where to save output files') do |v|
            options[:folder] = v
          end
        end

        opt_parser.parse!(argv)
        folder = options[:folder]
        extension = options[:extension]
        collection_filename = argv.first


        Dir.mkdir(folder)  unless Dir.exist?(folder)
        raise "Collection file not specified"  unless collection_filename
        raise "File `#{collection_filename}` not exist"  unless File.exist?(collection_filename)

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
      end

    end
  end
end
