require 'bioinform/conversion_algorithms/pwm2iupac_pwm_converter'

describe Bioinform::ConversionAlgorithms::PWM2IupacPWMConverter do
  let(:matrix) { [[1,2,3,1.567],[12,-11,12,0],[-1.1, 0.6, 0.4, 0.321]] }
  let(:pwm) { Bioinform::MotifModel::PWM.new(matrix) }
  context 'with default parameters' do
    let(:converter) { Bioinform::ConversionAlgorithms::PWM2IupacPWMConverter.new }
    specify{ expect(converter.iupac_alphabet).to eq Bioinform::NucleotideAlphabetWithN }
    specify 'can convert only PWMs' do
      pcm = Bioinform::MotifModel::PCM.new([[1,2,3,4],[2,2,2,4]])
      expect { converter.convert(pcm) }.to raise_error(Bioinform::Error)
    end
  end

  context 'with A,C,G,T,N-alphabet' do
    let(:converter) { Bioinform::ConversionAlgorithms::PWM2IupacPWMConverter.new(alphabet: Bioinform::NucleotideAlphabetWithN) }
    specify { expect( converter.convert(pwm) ).to be_kind_of Bioinform::MotifModel::PWM }
    specify { expect( converter.convert(pwm).alphabet ).to eq Bioinform::NucleotideAlphabetWithN }

    specify do
      expect( converter.convert(pwm).matrix ).to eq [
          [1,2,3,1.567, (1+2+3+1.567)/4.0],
          [12,-11,12,0, (12-11+12+0)/4.0],
          [-1.1, 0.6, 0.4, 0.321, (-1.1+0.6+0.4+0.321)/4.0]]
    end

    specify do
      custom_alphabet = Bioinform::ComplementableAlphabet.new([:A,:C,:G,:T,:N], [:T,:G,:C,:A,:N])
      custom_matrix = [[1,2,3,1.567, 0.1],[12,-11,12,0, 0.1],[-1.1, 0.6, 0.4, 0.321, 0.1]]
      pwm_w_custom_alphabet = Bioinform::MotifModel::PWM.new(custom_matrix, alphabet: custom_alphabet)
      expect { converter.convert(pwm_w_custom_alphabet) }.to raise_error(Bioinform::Error)
    end
    specify do
      custom_alphabet = Bioinform::ComplementableAlphabet.new([:A,:X,:Y,:T], [:T,:Y,:X,:A])
      pwm_w_custom_alphabet = Bioinform::MotifModel::PWM.new(matrix, alphabet: custom_alphabet)
      expect { converter.convert(pwm_w_custom_alphabet) }.to raise_error(Bioinform::Error)
    end

  end

  context 'with full-iupac alphabet' do
    let(:converter) { Bioinform::ConversionAlgorithms::PWM2IupacPWMConverter.new(alphabet: Bioinform::IUPACAlphabet) }
    specify { expect( converter.convert(pwm) ).to be_kind_of Bioinform::MotifModel::PWM }
    specify { expect( converter.convert(pwm).alphabet ).to eq Bioinform::IUPACAlphabet }

    specify do
      expect( converter.convert(pwm).matrix ).to eq [
          [1,2,3,1.567, (1+2)/2.0, (1+3)/2.0, (1+1.567)/2.0, (2+3)/2.0, (2+1.567)/2.0, (3+1.567)/2.0, (1+2+3)/3.0, (1+2+1.567)/3.0, (1+3+1.567)/3.0, (2+3+1.567)/3.0, (1+2+3+1.567)/4.0],
          [12,-11,12,0, (12-11)/2.0, (12+12)/2.0, (12+0)/2.0, (-11+12)/2.0, (-11+0)/2.0, (12+0)/2.0, (12-11+12)/3.0, (12-11+0)/3.0, (12+12+0)/3.0, (-11+12+0)/3.0, (12-11+12+0)/4.0],
          [-1.1, 0.6, 0.4, 0.321, (-1.1+0.6)/2.0, (-1.1+0.4)/2.0, (-1.1+0.321)/2.0, (0.6+0.4)/2.0, (0.6+0.321)/2.0, (0.4+0.321)/2.0, (-1.1+0.6+0.4)/3.0, (-1.1+0.6+0.321)/3.0, (-1.1+0.4+0.321)/3.0, (0.6+0.4+0.321)/3.0, (-1.1+0.6+0.4+0.321)/4.0]]
    end

    specify do
      custom_alphabet = Bioinform::ComplementableAlphabet.new([:A,:C,:G,:T,:N], [:T,:G,:C,:A,:N])
      custom_matrix = [[1,2,3,1.567, 0.1],[12,-11,12,0, 0.1],[-1.1, 0.6, 0.4, 0.321, 0.1]]
      pwm_w_custom_alphabet = Bioinform::MotifModel::PWM.new(custom_matrix, alphabet: custom_alphabet)
      expect { converter.convert(pwm_w_custom_alphabet) }.to raise_error(Bioinform::Error)
    end
    specify do
      custom_alphabet = Bioinform::ComplementableAlphabet.new([:A,:X,:Y,:T], [:T,:Y,:X,:A])
      pwm_w_custom_alphabet = Bioinform::MotifModel::PWM.new(matrix, alphabet: custom_alphabet)
      expect { converter.convert(pwm_w_custom_alphabet) }.to raise_error(Bioinform::Error)
    end
  end
end
