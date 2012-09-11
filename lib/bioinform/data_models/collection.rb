require 'ostruct'

module Bioinform
  class Collection
    attr_reader :collection, :parameters

    # collection name is a tag name for each motif in a collection. But motif can be included in several collections so have several tags
    def initialize(parameters = {})
      @collection = []
      @parameters = OpenStruct.new(parameters)
      yield @parameters  if block_given?
    end

    def size
      collection.size
    end

    def name
      parameters.name
    end

    def to_s
      "<Collection '#{name}'>"
    end
    
    def +(other)
      result = self.class.new
      each do |pm, infos|
        result.add_pm(pm, infos)
      end
      other.each do |pm, infos|
        result.add_pm(pm, infos)
      end
      result
    end

    def add_pm(pm, info)
      pm.mark(self)
      collection << [pm, info]
      self
    end
    
    def <<(pm)
      add_pm(pm, OpenStruct.new)
    end

    def each
      if block_given?
        collection.each{|pm, infos| yield [pm, infos]}
      else
        Enumerator.new(self, :each)
      end
    end
    
    def each_pm
      if block_given?
        each{|pm, infos| yield pm}
      else
        Enumerator.new(self, :each_pm)
      end
    end

    include Enumerable

    %w[pcm ppm pwm].each do |data_model|
      method_name = "each_#{data_model}".to_sym       #
      converter_method = "to_#{data_model}".to_sym    #
      define_method method_name do |&block|           # define_method :each_pcm do |&block|
        if block                                      #   if block
          each do |pm, infos|                         #     each do |pm, infos|
            block.call pm.send(converter_method)      #       block.call pm.send(:to_pcm)
          end                                         #     end
        else                                          #   else
          Enumerator.new(self, method_name)           #     Enumerator.new(self, :each_pcm)
        end                                           #   end
      end                                             # end
    end
    
    def ==(other)
      (collection == other.collection) && (parameters == other.parameters)
    rescue
      false
    end

  end
end