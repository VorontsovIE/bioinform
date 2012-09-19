require 'ostruct'
require_relative 'motif'

module Bioinform
  class Collection
    attr_accessor :collection
    attr_accessor :container

    include Parameters
    make_parameters :name

    # collection name is a tag name for each motif in a collection. But motif can be included in several collections so have several tags
    def initialize(parameters = {})
      @collection = []
      @container = []
      @parameters = OpenStruct.new(parameters)
      yield @parameters  if block_given?
    end

    def size
      container.size
    end

    def to_s(with_name = true)
      result = (with_name) ? "Collection: #{name.to_s}\n" : ''
      each do |pm, infos|
        result << pm.to_s << "\n\n"
      end
      result
    end

    def +(other)
      result = self.class.new
      collection.each do |pm, infos|
        result.collection << [pm, infos]
      end
      other.collection.each do |pm, infos|
        result.collection << [pm, infos]
      end
      container.each do |motif|
        result.container << motif
      end
      other.container.each do |motif|
        result.container << motif
      end
      result
    end

    def add_pm(pm, info)
#      pm.mark(self)
      collection << [pm, info]
      container << Motif.new(info.marshal_dump.merge(pm: pm))
      #### What if pm already is a Motif
      self
    end

    def <<(pm)
      add_pm(pm, OpenStruct.new)
    end

    def each(*args)
      if args.empty?
        if block_given?
          collection.each{|pm, infos| yield [pm, infos]}
        else
          Enumerator.new(self, :each)
        end
      else
        if block_given?
          container.each{|motif| yield( args.map{|arg| motif.parameters.send(arg)} ) }
        else
          Enumerator.new(self, :each, *args)
        end
      end
    end

    def each_motif
      if block_given?
        container.each{|motif| yield motif}
      else
        Enumerator.new(self, :each_motif)
      end
    end
    
    include Enumerable

    %w[pcm ppm pwm].each do |data_model|
      method_name = "each_#{data_model}".to_sym               #
      define_method method_name do |&block|                   # define_method :each_pcm do |&block|
        if block                                              #   if block
          container.each do |motif|                           #     container.each do |motif|
            block.call(motif.send(data_model))                #       block.call(motif.send(:pcm))
          end                                                 #     end
        else                                                  #   else
          Enumerator.new(self, method_name)                   #     Enumerator.new(self, :each_pcm)
        end                                                   #   end
      end                                                     # end
    end

    def ==(other)
      (parameters == other.parameters) && (container == other.container)
    rescue
      false
    end

  end
end