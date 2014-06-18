require_relative '../error'
require_relative '../data_models_2/pcm'
require_relative '../data_models_2/ppm'

module Bioinform
  module ConversionAlgorithms
    class PPM2PCMConverter
      def initialize(count: 100)
        @count = count
      end

      def convert(ppm)
        matrix = ppm.each_position.map do |pos|
          pos.map do |el|
            el * @count
          end
        end

        MotifModel::PCM.new(matrix)
      end
    end
  end
end
