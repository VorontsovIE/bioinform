module Bioinform
  class Error < ::StandardError
  end

  class ValidationError < Error
    attr_reader :validation_errors

    def initialize(msg, options = {})
      super(msg)
      @validation_errors = options.fetch(:validation_errors, [])
    end

    def to_s
      case @validation_errors
      when Array
        "#{super} (#{@validation_errors.join('; ')})"
      when ValidationResult
        "#{super}\n#{@validation_errors}"
      else
        "#{super} (#{@validation_errors})"
      end
    end
  end
end
