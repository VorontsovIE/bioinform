require_relative '../errors'
require_relative '../data_models'

module Bioinform
  module ConversionAlgorithms
    class PPM2PCMConverter
      attr_reader :count

      def initialize(count: 100)
        @count = count
      end

      def convert(ppm)
        raise Error, "#{self.class}#convert accepts only models acting as PPM"  unless MotifModel.acts_as_ppm?(ppm)
        matrix = ppm.each_position.map do |pos|
          pos.map do |el|
            el * @count
          end
        end

        pcm = MotifModel::PCM.new(matrix)
        if ppm.respond_to? :name
          pcm.named(ppm.name)
        else
          pcm
        end
      end
    end
  end
end
