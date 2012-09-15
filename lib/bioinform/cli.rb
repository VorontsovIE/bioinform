module Bioinform
  module CLI
    module Helpers
      def name_wo_extension(filename)
        File.join(File.dirname(filename), basename_wo_extension(filename))
      end
      def basename_wo_extension(filename)
        File.basename(filename, File.extname(filename))
      end
      def set_extension(filename, extension)
        "#{filename}.#{extension}"
      end
      def set_folder(folder, filename)
        File.join(folder, filename)
      end
      def basename_changed_extension(filename, extension)
        set_extension(basename_wo_extension(filename), extension)
      end
      def change_folder_and_extension(input_filename, extension, folder)
        set_folder(folder, basename_changed_extension(input_filename, extension))
      end
    end
  end
end

require_relative 'cli/merge_into_collection'
require_relative 'cli/pcm2pwm'
require_relative 'cli/split_motifs'