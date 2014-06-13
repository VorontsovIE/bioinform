require_relative 'pm'

module Bioinform
  module MotifModel
    class PCM < PM
      def validation_errors
        errors = super
        errors << "elements of PCM should be non-negative"  unless matrix.all?{|pos| pos.all?{|el| el >= 0 } }
        errors
      end

      def count
        counts = each_position.map{|pos| pos.inject(0.0, &:+)}
        count = counts.first
        diffs = counts.map{|pos_count| (pos_count - count).abs }
        counts_are_same = (diffs.max < count * 1e-3)
        raise Error, 'Different columns have different count'  unless counts_are_same
        count
      end
    end
  end
end
