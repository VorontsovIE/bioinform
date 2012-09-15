require_relative '../../lib/bioinform'
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
            #{__FILE__} [options] [<pm-files>...]

          Options:
            -h --help                 Show this screen.
            -n --name NAME            Specify name for a collection. Default filename is based on this parameter
            -o --output-file FILE     Output file for resulting collection
            -m --data-model MODEL     Data model: PM, PCM, PPM or PWM [default: PM]
            -p --plain-text           Output collection of motifs in plain text (motifs separated with newlines, no additional information included).
        DOCOPT

        doc.gsub!(/^#{doc[/\A +/]}/,'')
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
        
        
        
        
        if File.directory?(data_source)
          motifs = Dir.glob(File.join(data_source,'*')).sort.map do |filename|
            pwm = data_model.new(File.read(filename))
            pwm.name ||= File.basename(filename, File.extname(filename))
            pwm
          end
        elsif File.file?(data_source)
          input = File.read(data_source)
          motifs = data_model.split_on_motifs(input)
        elsif data_source == '.stdin'
          filelist = $stdin.read.shellsplit
          motifs = []
          filelist.each do |filename|
            motif = data_model.new(File.read(filename))
            motif.name ||= File.basename(filename, File.extname(filename))
            motifs << motif
          end
        else
          raise "Specified data source `#{data_source}` is neither directory nor file nor even .stdin"
        end

        
        
        
        
=end
      rescue Docopt::Exit => e
        puts e.message
      end

    end
  end
end