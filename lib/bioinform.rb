require_relative 'bioinform/version'
require_relative 'bioinform/support'
require_relative 'bioinform/errors'
require_relative 'bioinform/parsers'
require_relative 'bioinform/data_models'
require_relative 'bioinform/conversion_algorithms'
require_relative 'bioinform/formatters'
require_relative 'bioinform/cli'

require_relative 'bioinform/background'
require_relative 'bioinform/alphabet'

module Bioinform
  def self.get_model(data_model, matrix, name)
    Bioinform::MotifModel.const_get(data_model).new(matrix).named(name)
  end

  def self.get_model_from_string(data_model, matrix_string)
    motif_infos = Parser.choose(matrix_string).parse(matrix_string)
    get_model(data_model, motif_infos.matrix, name)
  end

  def self.get_pwm(data_model, matrix, background, pseudocount, effective_count)
    input_model = get_model_from_string(data_model, matrix)
    case input_model
    when MotifModel::PPM
      ppm2pcm_converter = ConversionAlgorithms::PPM2PCM.new(count: effective_count)
      pcm2pwm_converter = ConversionAlgorithms::PCM2PWM.new(background: background, pseudocount: pseudocount)
      pcm2pwm_converter.convert(ppm2pcm_converter.convert(input_model))
    when MotifModel::PCM
      pcm2pwm_converter = ConversionAlgorithms::PCM2PWM.new(background: background, pseudocount: pseudocount)
      pcm2pwm_converter.convert(input_model)
    when MotifModel::PWM
      input_model
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PWM creation failed (#{e})"
  end

  def self.get_pcm(data_model, matrix, effective_count)
    input_model = get_model_from_string(data_model, matrix)
    case input_model
    when MotifModel::PPM
      ppm2pcm_converter = ConversionAlgorithms::PPM2PCM.new(count: effective_count)
      ppm2pcm_converter.convert(input_model)
    when MotifModel::PCM
      input_model
    when MotifModel::PWM
      raise Error, 'Conversion PWM-->PCM not yet implemented'
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PCM creation failed (#{e})"
  end

  def self.get_ppm(data_model, matrix)
    input_model = get_model_from_string(data_model, matrix)
    case input_model
    when MotifModel::PPM
      input_model
    when MotifModel::PCM
      pcm2ppm_converter = ConversionAlgorithms::PCM2PPM.new
      pcm2ppm_converter.convert(input_model)
    when MotifModel::PWM
      raise Error, 'Conversion PWM-->PPM not yet implemented'
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PPM creation failed (#{e})"
  end
end
