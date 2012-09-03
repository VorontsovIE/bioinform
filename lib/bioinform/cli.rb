module Bioinform
  module CLI
    def self.output_filename(input_filename, extension, folder)
      File.join(folder, File.basename(input_filename, File.extname(input_filename)) + ".#{extension}")
    end
  end
end