require 'ostruct'
require 'active_support/core_ext/object/try'
module Bioinform
  class Motif
    include Parameters
    make_parameters :tags, :pcm,:pwm,:ppm,:name
    
    def mark(tag)
      tags << tag
    end

    def tagged?(tag)
      tags.any?{|t| (t.eql? tag) || (t.respond_to?(:name) && t.name && (t.name == tag)) }
    end
    
    # Motif.new(pcm: ..., pwm: ..., name: ...,threshold: ...)
    # Motif.new(my_pcm)
    def initialize(parameters = {})
      case parameters
      when PM
        pm = parameters
        motif_type = pm.class.name.downcase.sub(/^.+::/,'')
        sset_parameters(motif_type => pm)
      else
        set_parameters(parameters)
      end
      self.tags = []
    end
    
    #def pcm; parameters.pcm; end
    def pwm; parameters.pwm || pcm.try(:to_pwm); end
    def ppm; parameters.ppm || pcm.try(:to_ppm); end
    #def pcm=(pcm); parameters.pcm = pcm; end
    #def pwm=(pwm); parameters.pwm = pwm; end
    #def ppm=(ppm); parameters.ppm = ppm; end
    def name; parameters.name || pwm.try(:name) || pcm.try(:name) || ppm.try(:name); end
    
    
    def method_missing(meth, *args)
      parameters.__send__(meth, *args)
    end
    
  end
end