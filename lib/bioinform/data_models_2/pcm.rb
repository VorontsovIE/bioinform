require_relative 'pm'

module Bioinform
  module MotifModel
    class PCM < PM
      def valid?
        super && matrix.all?{|pos| pos.all?{|el| el >= 0 } }
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
