require_relative 'bioinform/version'
require_relative 'bioinform/support'
require_relative 'bioinform/parsers'
require_relative 'bioinform/data_models'
require_relative 'bioinform/conversion_algorithms'
require_relative 'bioinform/formatters'
require_relative 'bioinform/cli'

require_relative 'bioinform/background'
require_relative 'bioinform/alphabet'
require_relative 'bioinform/data_models_2/pm'
require_relative 'bioinform/data_models_2/pcm'
require_relative 'bioinform/data_models_2/pwm'
require_relative 'bioinform/data_models_2/ppm'
require_relative 'bioinform/data_models_2/named_model'

module Bioinform
  class Error < StandardError
  end

  def self.get_pwm(data_model, matrix, background, pseudocount, effective_count)
    pm = Bioinform.const_get(data_model).new(matrix)
    pm.set_parameters(background: background)
    if pseudocount && ! pseudocount.blank? && [:PCM,:PPM].include?(data_model.to_sym)
      pm.set_parameters(pseudocount: pseudocount)
    end
    if effective_count && [:PPM].include?(data_model.to_sym)
      pm.set_parameters(effective_count: effective_count)
    end
    pm.to_pwm
  rescue => e
    raise Error, "PWM creation failed (#{e})"
  end

  def self.get_pcm(data_model, matrix, effective_count)
    pm = Bioinform.const_get(data_model).new(matrix)
    if effective_count && [:PPM].include?(data_model.to_sym)
      pm.set_parameters(effective_count: effective_count)
    end
    pm.to_pcm
  rescue => e
    raise Error, "PWM creation failed (#{e})"
  end

  def self.get_ppm(data_model, matrix)
    Bioinform.const_get(data_model).new(matrix).to_ppm
  rescue => e
    raise Error, "PWM creation failed (#{e})"
  end
end
