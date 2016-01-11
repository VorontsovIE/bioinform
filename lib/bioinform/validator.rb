module Bioinform
  class ValidationResult
    attr_reader :errors, :warnings
    def initialize(errors: [], warnings: [])
      @errors = errors.freeze
      @warnings = warnings.freeze
    end

    def self.all_ok
      self.new(errors: [], warnings: [])
    end

    def valid?
      errors.empty?
    end

    def to_s
      msg = ""

      if errors && !errors.empty?
        msg += "Errors:\n" + errors.join("\n") + "\n"
      end

      if warnings && !warnings.empty?
        msg += "Warnings:\n" + warnings.join("\n")
      end

      msg.empty? ? "{No errors, no warnings}" : "{#{msg}}"
    end

    def with_errors(additional_errors)
      ValidationResult.new(errors: errors + additional_errors, warnings: warnings)
    end

    def with_warnings(additional_warnings)
      ValidationResult.new(errors: errors, warnings: warnings + additional_warnings)
    end

    # errors from both operands
    def +(other)
      ValidationResult.new(errors: errors + other.errors, warnings: warnings + other.warnings)
    end

    def hash
      [@errors, @warnings].hash
    end
    def eql?(other)
      (other.class == self.class) && (errors == other.errors) && (warnings == other.warnings)
    end
    def ==(other)
      other.is_a?(ValidationResult) && (errors == other.errors) && (warnings == other.warnings)
    end
  end

  class Validator
    def initialize(&block)
      if block_given?
        @validation_block = block
      else
        @validation_block = ->(*args, &b){ ValidationResult.new }
      end
    end

    def validate_params(*args, &block)
      @validation_block.call(*args, &block)
    rescue => e
      msg = "Unexpected error occured during validation: #{e.message}. Backtrace:\n" + e.backtrace.join("\n")
      ValidationResult.new(errors: [msg])
    end

    # Validate both
    def *(other)
      Validator.new{|*args, &b|
        validate_params(*args, &b) + other.validate_params(*args, &b)
      }
    end

    # treat warnings as errors
    def make_strict
      Validator.new{|*args, &block|
        result = self.validate_params(*args, &block)
        ValidationResult.new(errors: result.errors + result.warnings)
      }
    end
  end
end
