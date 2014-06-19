module Bioinform
  module MotifModel
    class NamedModel
      attr_reader :model, :name
      def initialize(model, name)
        @model, @name = model, name
      end

      def motif_klasses
        Bioinform::MotifModel.constants.map{|konst| Bioinform::MotifModel.const_get(konst) }.select{|konst| konst.is_a? Class }
      end

      def motif?(object)
        motif_klasses.any?{|klass| object.is_a?(klass) }
      end

      private :motif_klasses, :motif?

      def method_missing(meth, *args, &block)
        result = model.public_send(meth, *args, &block)
        if motif?(result) && ! result.is_a?(self.class)
          self.class.new(result, name)
        else
          result
        end
      end

      def to_s
        ">#{name}\n#{model.to_s}"
      end

      def ==(other)
        model == other.model && name == other.name
      end
    end
  end
end
