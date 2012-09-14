module Bioinform
  module CLI
    module Helpers
      def basename_wo_extension(filename)
        File.basename(filename, File.extname(filename))
      end
      def set_extension(filename, extension)
        "#{filename}.#{extension}"
      end
      def set_folder(folder, filename)
        File.join(folder, filename)
      end
      def change_extension(filename, extension)
        set_extension(basename_wo_extension(filename), extension)
      end
      def change_folder_and_extension(input_filename, extension, folder)
        set_folder(folder, change_extension(input_filename, extension))
      end
    end
  end
end