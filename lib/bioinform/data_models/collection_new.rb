require 'ostruct'
require_relative '../support'
require_relative 'motif'

class Collection
  attr_accessor :container
  include Bioinform::Parameters
  make_parameters :name
  
  def initialize(parameters = {})
    @container = []
    set_parameters(parameters)
  end
  
  def <<(motif)
    case motif
    when Motif
      container << motif
    else
      container << Motif.new(motif)
    end
    motif.mark(self)
    self
  end
  
  def size
    container.size
  end
  
  def pcm
    container.map{|motif| motif.pcm }
  end
  
  def pwm
    container.map{|motif| motif.pwm || motif.pcm.to_pwm }
  end
  
  def each(&block)
    container.each(&block)
  end
  
  def ==(other)
    (container == other.container) && (parameters == other.parameters)
  end
  
  def [](index)
    container[index]
  end
  
  # ????
  def add_motif(motif, info)
    self << motif.set_parameters(info)
  end
  #alias_method :add_motif, :<<
  #alias_method :add_pm, :add_motif
end