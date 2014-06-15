require 'ostruct'
require_relative '../support/third_part/active_support/core_ext/object/try'
module Bioinform
  class Motif
    attr_accessor :pm, :pcm, :pwm, :ppm, :name, :original_data_model

    # 0)Motif.new()
    # 1)Motif.new(pcm: ..., pwm: ..., name: ...,threshold: ...)
    # 2)Motif.new(my_pcm)
    # 3)Motif.new(pm: my_pcm, threshold: ...)
    # 2) and 3) cases will automatically choose data model
    #### What if pm already is a Motif
    def initialize(parameters = {})
      case parameters
      when PM
        pm = parameters
        motif_type = pm.class.name.downcase.sub(/^.+::/,'').to_sym
        self.original_data_model = motif_type
        send("#{motif_type}=", pm)
      when Hash
        if parameters.has_key?(:pm) && parameters[:pm].is_a?(PM)
          pm = parameters.delete(:pm)
          motif_type = pm.class.name.downcase.sub(/^.+::/,'').to_sym
          self.original_data_model = motif_type
          send("#{motif_type}=", pm)
        else
          @pm = parameters[:pm]
        end
        @pcm ||= parameters[:pcm]
        @ppm ||= parameters[:ppm]
        @pwm ||= parameters[:pwm]
        @original_data_model ||= parameters[:original_data_model]
        @name ||= parameters[:name]
      else
        raise ArgumentError, "Motif::new doesn't accept argument #{parameters} of class #{parameters.class}"
      end
    end

    def pm; ((@original_data_model || :pm).to_sym == :pm) ? @pm : send(@original_data_model); end
    #def pcm; parameters.pcm; end
    def pwm; @pwm || @pcm.try(:to_pwm); end
    def ppm; @ppm || @pcm.try(:to_ppm); end
    def name; @name || pm.name; end

    def ==(other)
      other.class == self.class &&
      @pm == other.instance_variable_get("@pm") &&
      @pcm == other.instance_variable_get("@pcm") &&
      @pwm == other.instance_variable_get("@pwm") &&
      @ppm == other.instance_variable_get("@ppm") &&
      @name == other.instance_variable_get("@name") &&
      @original_data_model == other.instance_variable_get("@original_data_model")
    end

    # def to_s
    #   parameters.to_s
    # end
  end
end
