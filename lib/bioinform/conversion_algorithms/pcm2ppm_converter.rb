require_relative '../data_models_2/pcm'
require_relative '../data_models_2/ppm'

module Bioinform
  module ConversionAlgorithms
    module PCM2PPMConverter
    
      # parameters hash is ignored
      def self.convert(pcm, parameters = {})
        matrix = pcm.each_position.map do |pos|
          pos.map do |el|
            el.to_f / pcm.count
          end
        end
        PPM.new(matrix: matrix, name: pcm.name, background: pcm.background, pseudocount: pcm.pseudocount)
      end
    end

    class PCM2PPMConverter_
      def convert(pcm)
        matrix = pcm.each_position.map do |pos|
          count = pos.inject(0.0, &:+)
          pos.map {|el| el / count }
        end
        MotifModel::PCM.new(matrix)
      end
    end
  end
end
