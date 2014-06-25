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

        motif_list_string = File.read(collection_filename)
        coll = MotifSplitter.new.split(motif_list_string).map do |motif_string|
          motif_info = MatrixParser.new.parse(motif_string)
          MotifModel::PM.new(motif_info[:matrix]).named(motif_info[:name])
        end

        coll.each do |motif|
          File.open(set_folder(folder, set_extension(motif.name, extension || 'mat')), 'w'){|f| f.puts motif }
        end
      end

    end
  end
end
