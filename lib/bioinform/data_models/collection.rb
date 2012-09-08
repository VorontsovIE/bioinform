module Bioinform
  class Collection
    attr_reader :collection
    attr_accessor :name

    #  name is a tag name for each motif in a . But motif can be included in several s so have several tags
    def initialize(name = nil)
      @collection = []
      @name = name
    end

    def size
      collection.size
    end

    def to_s
      "<Collection '#{name}'>"
    end

    def +(other)
      result = self.class.new
      each do |pm|
        result << pm
      end
      other.each do |pm|
        result << pm
      end
      result
    end

    def <<(pm)
      pm.mark(self)
      collection << pm
      self
    end

    def select_tagged(tag)
      result = self.class.new
      each do |pm|
        result << pm  if pm.tagged?(tag)
      end
      result
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