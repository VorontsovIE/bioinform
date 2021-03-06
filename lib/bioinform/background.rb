require_relative 'errors'

# TODO: generalize for the case of different alphabet
module Bioinform
  # it also tags Frequencies and WordwiseBackground classes so that .is_a?(Bioinform::Background) is true for them
  module Background
    def self.wordwise
      Bioinform::Background::Wordwise
    end
    def self.uniform
      Bioinform::Background::Uniform
    end

    def self.from_frequencies(frequencies)
      Frequencies.new(frequencies)
    end

    def self.from_gc_content(gc_content)
      raise Error, 'GC-content should be withing range [0;1]'  unless (0..1).include?(gc_content)
      p_at = (1.0 - gc_content) / 2.0
      p_cg = gc_content / 2.0
      Frequencies.new([p_at, p_cg, p_cg, p_at])
    end

    def self.from_string(str)
      return wordwise  if str.downcase == 'wordwise'
      return uniform  if str.downcase == 'uniform'
      arr = str.strip.split(',').map(&:to_f)
      arr == [1,1,1,1] ? wordwise : Bioinform::Frequencies.new(arr)
    end
  end

  module FrequencyCalculations
    # sum(values_i * p_i)
    def mean(values)
      4.times.map{|i| values[i] * frequencies[i] }.inject(0.0, &:+)
    end
    # sum(values_i^2 * p_i)
    def mean_square(values)
      4.times.map{|i| values[i] * values[i] * frequencies[i] }.inject(0.0, &:+)
    end

    def symmetric?
      frequencies == frequencies.reverse
    end
  end

  class Frequencies
    include FrequencyCalculations
    include Bioinform::Background
    def initialize(frequencies)
      @frequencies = frequencies
      raise Error, 'Frequencies should have 4 components' unless frequencies.length == 4
      raise Error, 'Frequencies should be in [0;1]' unless frequencies.all?{|el| (0..1).include?(el) }
      raise Error, 'Sum of Background frequencies should be equal to 1' unless (frequencies.inject(0.0, &:+) - 1.0).abs < 1e-4
    end

    attr_reader :frequencies
    def counts; frequencies; end
    def volume; 1; end
    def wordwise?; false; end


    def ==(other)
      self.class == other.class && frequencies == other.frequencies
    end

    def to_s
      counts.join(',')
    end
  end

  class WordwiseBackground
    UniformFrequencies = [0.25, 0.25, 0.25, 0.25]
    WordwiseCounts = [1, 1, 1, 1]
    include FrequencyCalculations
    include Bioinform::Background

    def frequencies; UniformFrequencies; end
    def counts; WordwiseCounts; end
    def volume; 4; end
    def wordwise?; true; end

    def ==(other)
      self.class == other.class
    end

    def to_s
      'wordwise'
    end
  end

  module Background
    Uniform = Bioinform::Frequencies.new([0.25, 0.25, 0.25, 0.25])
    Wordwise = Bioinform::WordwiseBackground.new
  end
end
