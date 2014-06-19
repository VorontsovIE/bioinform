require_relative 'parsers'

# require_relative 'data_models/pm'
# require_relative 'data_models/pcm'
# require_relative 'data_models/ppm'
# require_relative 'data_models/pwm'

module Bioinform
  module MotifModel
    def self.acts_as_pcm?(pcm)
      pcm.is_a?(MotifModel::PCM) || pcm.is_a?(MotifModel::NamedModel) && acts_as_pcm?(pcm.model)
    end
    def self.acts_as_ppm?(ppm)
      ppm.is_a?(MotifModel::PPM) || ppm.is_a?(MotifModel::NamedModel) && acts_as_ppm?(ppm.model)
    end
    def self.acts_as_pwm?(pwm)
      pwm.is_a?(MotifModel::PWM) || pwm.is_a?(MotifModel::NamedModel) && acts_as_pwm?(pwm.model)
    end
  end
end
