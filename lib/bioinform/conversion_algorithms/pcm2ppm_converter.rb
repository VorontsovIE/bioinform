require_relative '../data_models_2/pcm'
require_relative '../data_models_2/ppm'
require_relative '../data_models'

module Bioinform
  module ConversionAlgorithms
    class PCM2PPMConverter
      def convert(pcm)
        raise Error, "#{self.class}#convert accepts only models acting as PCM"  unless MotifModel.acts_as_pcm?(pcm)
        matrix = pcm.each_position.map do |pos|
          count = pos.inject(0.0, &:+)
          pos.map {|el| el / count }
        end
        ppm = MotifModel::PPM.new(matrix)
        if pcm.respond_to? :name
          ppm.named(pcm.name)
        else
          ppm
        end
      end
    end
  end
end
