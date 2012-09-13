require_relative '../../lib/bioinform'
require 'docopt'
require 'shellwords'
require 'yaml'

module Bioinform
  module CLI
    module MergeIntoCollection
      def self.main(argv)
        doc = <<-DOCOPT
Tool for merging multiple motifs into a single collection file.
It takes motif files or (entire collections) and creates a collection consisting of them all. By default motifs are treated simply as matrices(PM), but you can (possibly should) specify data model. Output file by default are in YAML-format but it's possible to create plain text file. YAML collections are useful if you want to provide additional information for motifs in collection with another tool, plain text is more readable by humans.

Usage:
  #{__FILE__} [options] [<pm-files>...]

Options:
  -h --help                 Show this screen.
  -n --name NAME            Specify name for a collection. Default filename is based on this parameter
  -o --output-file FILE     Output file for resulting collection
  -m --data-model MODEL     Data model: PM, PCM, PPM or PWM [default: PM]
  -p --plain-text           Output collection of motifs in plain text (motifs separated with newlines, no additional information included).
        DOCOPT

        options = Docopt::docopt(doc, argv: argv)
        p options
=begin
        plain_text = options['--plain-text']
        output_file = options['--output-file']
        data_model = Bioinform.const_get(options['--data-model'].upcase)

        if options['<pm-files>'].empty?
          filelist = $stdin.read.shellsplit
        else
          filelist = options['<pm-files>']
        end

        collection = Collection.new

        filelist.each do |pm_filename|
          input = File.read(pm_filename)
          data_model.choose_parser(input).split_on_motifs(input, data_model).each do |pm|
            collection << pm
          end
        end

        if plain_text
          File.open(output_file, 'w'){|f| YAML.dump(collection, f) }
        else
          File.open(output_file, 'w'){|f| f.puts(collection.to_s) }
        end
=end
      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end