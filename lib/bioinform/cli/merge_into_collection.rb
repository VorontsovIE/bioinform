require_relative '../../bioinform'
require 'docopt'
require 'shellwords'
require 'yaml'

module Bioinform
  module CLI
    module MergeIntoCollection
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        doc = <<-DOCOPT
          Tool for merging multiple motifs into a single collection file.
          It takes motif files or (entire collections) and creates a collection consisting of them all. By default motifs are treated simply as matrices(PM), but you can (possibly should) specify data model. Output file by default are in YAML-format but it's possible to create plain text file. YAML collections are useful if you want to provide additional information for motifs in collection with another tool, plain text is more readable by humans.

          Usage:
            merge_into_collection [options] [<pm-files>...]

          Options:
            -h --help                 Show this screen.
            -n --name NAME            Specify name for a collection. Default filename is based on this parameter
            -o --output-file FILE     Output file for resulting collection
            -m --data-model MODEL     Data model: PM, PCM, PPM or PWM [default: PM]
            -p --plain-text           Output collection of motifs in plain text (motifs separated with newlines, no additional information included).
        DOCOPT

        doc.gsub!(/^#{doc[/\A +/]}/,'')
        options = Docopt::docopt(doc, argv: argv)

        plain_text = options['--plain-text']
        name = options['--name']
        if options['--plain-text']
          output_file = options['--output-file'] || set_extension(name || 'collection', 'txt')
        else
          output_file = options['--output-file'] || set_extension(name || 'collection', 'yaml')
        end
        data_model = Bioinform.const_get(options['--data-model'].upcase)

        if options['<pm-files>'].empty?
          filelist = $stdin.read.shellsplit
        else
          filelist = options['<pm-files>']
        end
        
        filelist = filelist.map do |data_source|
          if File.directory? data_source
            Dir.glob(File.join(data_source, '*'))
          elsif File.file? data_source
            data_source
          else
            raise "File or directory #{data_source} can't be found"
          end
        end.flatten

        collection = Collection.new
        collection.name = name  if name

        filelist.each do |filename|
          data_model.split_on_motifs(File.read(filename)).each do |pm|
            pm.name ||= File.basename(filename, File.extname(filename))
            collection << pm
          end
        end

        if plain_text
          File.open(output_file, 'w') do |f|
            collection.each(options['--data-model'].downcase) do |pm|
              f.puts(pm.to_s + "\n\n")
            end
          end
        else
          File.open(output_file, 'w'){|f| YAML.dump(collection, f) }
        end
        
      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end