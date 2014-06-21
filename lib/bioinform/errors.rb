module Bioinform
  class Error < ::StandardError
  end

  class ValidationError < Error
    attr_reader :validation_errors
    def initialize(msg, errors)
      super(msg)
      @validation_errors = errors
    end
    def to_s
      "#{super} (#{@validation_errors.join('; ')})"
    end
  end
end
