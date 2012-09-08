module Bioinform
  class Collection
    attr_reader :
    attr_accessor :name

    #  name is a tag name for each motif in a . But motif can be included in several s so have several tags
    def initialize(name = nil)
      @ = []
      @name = name
    end
    
    def size
      .size
    end
    
    def to_s
      "<Collection '#{name}'>"
    end

    def +(other)
      resulting_ = self.class.new
      each do |pm|
        resulting_ << pm
      end
      other.each do |pm|
        resulting_ << pm
      end
      resulting_
    end

    def <<(pm)
      pm.mark(self)
       << pm
      self
    end
    
    def select_tagged(tag)
      resulting_ = self.class.new
      each do |pm|
        resulting_ << pm  if pm.tagged?(tag)
      end
      resulting_
    end

    def each
      if block_given?
        .each{|pm| yield pm}
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