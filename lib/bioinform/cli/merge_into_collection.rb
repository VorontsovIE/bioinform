require_relative '../../bioinform'
require 'optparse'
require 'shellwords'
require 'yaml'

module Bioinform
  module CLI
    module MergeIntoCollection
      extend Bioinform::CLI::Helpers
      def self.main(argv)
        options = {data_model: 'PM'}
        opt_parser = OptionParser.new do |opts|
          opts.version = ::Bioinform::VERSION
          opts.banner = "Tool for merging multiple motifs into a single collection file.\n" +
                        "\n" +
                        "It takes motif files or (entire collections) and creates a collection consisting of them all.\n" +
                        "By default motifs are treated simply as matrices(PM), but you can (possibly should) specify data model.\n" +
                        "Output file by default are in YAML-format but it's possible to create plain text file.\n" +
                        "YAML collections are useful if you want to provide additional information for motifs\n" +
                        "in collection with another tool, " +
                        "plain text is more readable by humans.\n" +
                        "\n" +
                        "Usage:\n" +
                        "  merge_into_collection [options] [<pm-files>...]"

          opts.on('-n', '--name NAME', 'Specify name for a collection. Default filename is based on this parameter') do |v|
            options[:name] = v
          end
          opts.on('-o', '--output-file FILE', 'Output file for resulting collection') do |v|
            options[:output_file] = v
          end
          opts.on('-m', '--data-model MODEL', 'Data model: PM, PCM, PPM or PWM [default: PM]') do |v|
            options[:data_model] = v.to_sym
          end
          opts.on('-p', '--plain-text', 'Output collection of motifs in plain text (motifs separated with newlines, no additional information included).') do
            options[:plain_text] = true
          end
        end

        opt_parser.parse!(argv)

        if argv.empty?
          filelist = $stdin.read.shellsplit
        else
          filelist = argv
        end

        plain_text = options[:plain_text]
        name = options[:name]
        if options[:plain_text]
          output_file = options[:output_file] || set_extension(name || 'collection', 'txt')
        else
          output_file = options[:output_file] || set_extension(name || 'collection', 'yaml')
        end
        data_model = Bioinform.const_get(options[:data_model].upcase)

        
        filelist = filelist.map do |data_source|
          if File.directory? data_source
            Dir.glob(File.join(data_source, '*')).sort
          elsif File.file? data_source
            data_source
          else
            raise "File or directory #{data_source} can't be found"
          end
        end.flatten

        collection = Collection.new
        collection.name = name  if name

        filelist.each do |filename|
          Parser.split_on_motifs(File.read(filename), data_model).each do |pm|
            pm.name ||= File.basename(filename, File.extname(filename))
            collection << pm
          end
        end

        if plain_text
          File.open(output_file, 'w') do |f|
            collection.each(options[:data_model].downcase) do |pm|
              f.puts(pm.to_s + "\n\n")
            end
          end
        else
          File.open(output_file, 'w'){|f| YAML.dump(collection, f) }
        end
        
      rescue => e
        puts e.message
      end

    end
  end
end
