require 'ostruct'
require 'active_support/core_ext/object/try'
module Bioinform
  class Motif
    include Parameters
    make_parameters :pcm,:pwm,:ppm, :name
    # 0)Motif.new()
    # 1)Motif.new(pcm: ..., pwm: ..., name: ...,threshold: ...)
    # 2)Motif.new(my_pcm)
    # 3)Motif.new(pm: my_pcm, threshold: ...)
    # 2) and 3) cases will automatically choose data model
    def initialize(parameters = {})
      case parameters
      when PM
        pm = parameters
        motif_type = pm.class.name.downcase.sub(/^.+::/,'')
        set_parameters(motif_type => pm)
      when Hash
        pm = parameters.delete(:pm)
        set_parameters(parameters)
        if pm
          motif_type = pm.class.name.downcase.sub(/^.+::/,'')
          set_parameters(motif_type => pm)
        end
      end
    end
    
    #def pcm; parameters.pcm; end
    def pwm; parameters.pwm || pcm.try(:to_pwm); end
    def ppm; parameters.ppm || pcm.try(:to_ppm); end
    #def pcm=(pcm); parameters.pcm = pcm; end
    #def pwm=(pwm); parameters.pwm = pwm; end
    #def ppm=(ppm); parameters.ppm = ppm; end
    #def name; parameters.name || pwm.try(:name) || pcm.try(:name) || ppm.try(:name); end
    
    
    def method_missing(meth, *args)
      parameters.__send__(meth, *args)
    end
    
  end
end