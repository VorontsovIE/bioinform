require 'bioinform/background'

describe Bioinform::Frequencies do
  specify { expect{Bioinform::Frequencies.new([1,1,1,1]) }.to raise_error Bioinform::Error }
  specify { expect{Bioinform::Frequencies.new([0.3,0.3,0.3,0.3]) }.to raise_error Bioinform::Error }
  specify { expect{Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }.not_to raise_error }
  specify { expect{Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }.not_to raise_error }

  let(:frequencies) { Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }
  specify { expect(frequencies.frequencies).to eq [0.2,0.3,0.3,0.2] }
  specify { expect(frequencies.counts).to eq [0.2,0.3,0.3,0.2] }
  specify { expect(frequencies.volume).to eq 1 }
  specify { expect(frequencies).not_to be_wordwise }
  specify { expect(frequencies).to eq Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }
  specify { expect(frequencies).not_to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }

  specify { expect(Bioinform::Frequencies.new([0.2,0.3,0.3,0.2])).not_to eq Bioinform::WordwiseBackground.new }
  specify { expect(Bioinform::Frequencies.new([0.25,0.25,0.25,0.25])).not_to eq Bioinform::WordwiseBackground.new }

  specify { expect(frequencies.mean([1,2,3,-4])).to eq(0.2*1 + 0.3*2 + 0.3*3 + 0.2*(-4)) }
  specify { expect(frequencies.mean_square([1,2,3,-4])).to eq(0.2*1*1 + 0.3*2*2 + 0.3*3*3 + 0.2*(-4)*(-4)) }

end

describe Bioinform::WordwiseBackground do
  specify { expect{Bioinform::WordwiseBackground.new }.not_to raise_error }
  let(:frequencies) { Bioinform::WordwiseBackground.new }
  specify { expect(frequencies.frequencies).to eq [0.25,0.25,0.25,0.25] }
  specify { expect(frequencies.counts).to eq [1,1,1,1] }
  specify { expect(frequencies.volume).to eq 4 }
  specify { expect(frequencies).to be_wordwise }
  specify { expect(frequencies).to eq Bioinform::WordwiseBackground.new }
  specify { expect(frequencies).not_to eq Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }
  specify { expect(frequencies).not_to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }

  specify { expect(frequencies.mean([1,2,3,-4])).to eq(0.25*1 + 0.25*2 + 0.25*3 + 0.25*(-4)) }
  specify { expect(frequencies.mean_square([1,2,3,-4])).to eq(0.25*1*1 + 0.25*2*2 + 0.25*3*3 + 0.25*(-4)*(-4)) }
end

describe Bioinform::Background do
  specify { expect(Bioinform::Background.wordwise).to eq Bioinform::WordwiseBackground.new }
  specify { expect(Bioinform::Background::WordwiseBackground).to eq Bioinform::WordwiseBackground.new }
  specify { expect(Bioinform::Background.uniform).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }
  specify { expect(Bioinform::Background::UniformBackground).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }

  specify { expect(Bioinform::Background.from_gc_content(0.5)).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }
  specify { expect(Bioinform::Background.from_gc_content(0.6)).to eq Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }

  specify { expect(Bioinform::Background.from_string('0.2,0.3,0.3,0.2')).to eq Bioinform::Frequencies.new([0.2,0.3,0.3,0.2]) }
  specify { expect(Bioinform::Background.from_string('0.25,0.25,0.25,0.25')).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }
  specify { expect(Bioinform::Background.from_string('1,1,1,1')).to eq Bioinform::WordwiseBackground.new }
  specify { expect(Bioinform::Background.from_string('uniform')).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }
  specify { expect(Bioinform::Background.from_string('UNIFORM')).to eq Bioinform::Frequencies.new([0.25,0.25,0.25,0.25]) }
  specify { expect(Bioinform::Background.from_string('wordwise')).to eq Bioinform::WordwiseBackground.new }
  specify { expect{Bioinform::Background.from_string('0.25,0.25,0.25')}.to raise_error Bioinform::Error }
  specify { expect{Bioinform::Background.from_string('unifromm')}.to raise_error Bioinform::Error }
end
