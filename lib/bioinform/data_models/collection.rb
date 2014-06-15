require 'ostruct'
require_relative 'motif'

module Bioinform
  class Collection
    attr_accessor :container
    attr_accessor :name

    # collection name is a tag name for each motif in a collection. But motif can be included in several collections so have several tags
    def initialize(parameters = {})
      @container = []
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
      container << Motif.new(info.to_h.merge(pm: pm))
      #### What if pm already is a Motif
      self
    end

    def <<(pm)
      add_pm(pm, {})
    end

    # collection.each{|motif| ... }
    # collection.each(:pwm, :threshold){|pwm,threshold| }
    def each(*args)
      if block_given?
        if args.empty?
          container.each{|motif| yield motif}
        else
          container.each{|motif| yield( *args.map{|arg| motif.send(arg)} ) }
        end
      else
        self.to_enum(:each, *args)
      end
    end

    include Enumerable

    def ==(other)
      (self.class == other.class) && (name == other.name) && (container == other.container)
    rescue
      false
    end

    def empty?
      container.empty?
    end
  end
end
