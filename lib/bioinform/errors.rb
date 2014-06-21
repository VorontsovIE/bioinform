module Bioinform
  class Error < ::StandardError
  end

  class ValidationError < Error
    attr_reader :validation_errors

    def initialize(msg, validation_errors: [])
      super(msg)
      @validation_errors = validation_errors
    end

    def to_s
      "#{super} (#{@validation_errors.join('; ')})"
    end
  end
end
