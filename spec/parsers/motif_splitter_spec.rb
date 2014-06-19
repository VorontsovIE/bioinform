require 'bioinform/parsers/motif_splitter'

describe Bioinform::MotifSplitter do
  let(:motif_splitter) { Bioinform::MotifSplitter.new }

  let(:motif_unnamed) { "1 2 3 4\n"+"5\t6\t7\t8" }
  let(:motif_with_floats) { "motif2\n  1.0 1.1 1.2 1.3\n  14 15 16 17\n  19 20 21 22" }
  let(:motif_with_signs_and_exponents) { "> motif3\n-2.0 1.3e-3 -5.47 5.2\n+3.4 7 3 3" }
  specify do
    input = motif_unnamed + "\n" + motif_with_floats + "\n" + motif_with_signs_and_exponents
    expect(motif_splitter.split(input)).to eq [motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
    expect(motif_splitter.split(input+"\n")).to eq [motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
    expect(motif_splitter.split("Motif1 name\n"+input)).to eq ["Motif1 name\n"+motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
  end
  specify { expect(motif_splitter.split(motif_unnamed + "\n\n" + motif_unnamed)).to eq [motif_unnamed, motif_unnamed] }
  specify { expect(motif_splitter.split(motif_unnamed + "\n\n\n" + motif_unnamed)).to eq [motif_unnamed, motif_unnamed] }
end
