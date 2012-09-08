module Bioinform
  class Collection
    attr_reader :collection
    attr_accessor :collection_name

    # collection name is a tag name for each motif in a collection. But motif can be included in several collections so have several tags
    def initialize(name = nil)
      @collection = []
      @collection_name = name
    end
    
    def size
      collection.size
    end

    def +(other)
      resulting_collection = self.class.new
      each do |pm|
        resulting_collection << pm
      end
      other.each do |pm|
        resulting_collection << pm
      end
      resulting_collection
    end

    def <<(pm)
      pm.mark(collection_name)
      collection << pm
      self
    end
    
    def select_tagged(tag)
      resulting_collection = self.class.new
      each do |pm|
        resulting_collection << pm  if pm.tagged?(tag)
      end
      resulting_collection
    end

    def each
      if block_given?
        collection.each{|pm| yield pm}
      else
        Enumerator.new(self, :each)
      end
    end
    
    include Enumerable

    def each_pcm
      if block_given?
        each{|pm| yield pm.to_pcm }
      else
        Enumerator.new(self, :each_pcm)
      end
    end

    def each_pwm
      if block_given?
        each{|pm| yield pm.to_pwm }
      else
        Enumerator.new(self, :each_pwm)
      end
    end

    def each_ppm
      if block_given?
        each{|pm| yield pm.to_ppm }
      else
        Enumerator.new(self, :each_ppm)
      end
    end
  end
end