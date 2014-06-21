require 'bioinform/parsers/motif_splitter'

describe Bioinform::MotifSplitter do
  let(:motif_unnamed) { "1 2 3 4\n"+"5\t6\t7\t8" }
  let(:motif_with_floats) { "motif2\n  1.0 1.1 1.2 1.3\n  14 15 16 17\n  19 20 21 22" }
  let(:motif_with_signs_and_exponents) { "> motif3\n-2.0 1.3e-3 -5.47 5.2\n+3.4 7 3 3" }

  context 'default splitter\n' do
    let(:motif_splitter) { Bioinform::MotifSplitter.new }

    specify do
      input = motif_unnamed + "\n" + motif_with_floats + "\n" + motif_with_signs_and_exponents
      expect(motif_splitter.split(input)).to eq [motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
    end

    specify do
      input = motif_unnamed + "\n" + motif_with_floats + "\n" + motif_with_signs_and_exponents + "\n"
      expect(motif_splitter.split(input)).to eq [motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
    end

    specify do
      input = "Motif1 name\n" + motif_unnamed + "\n" + motif_with_floats + "\n" + motif_with_signs_and_exponents
      expect(motif_splitter.split(input)).to eq ["Motif1 name\n" + motif_unnamed, motif_with_floats, motif_with_signs_and_exponents]
    end

    specify { expect(motif_splitter.split(motif_unnamed + "\n\n" + motif_unnamed)).to eq [motif_unnamed, motif_unnamed] }

    specify { expect(motif_splitter.split(motif_unnamed + "\n\n\n" + motif_unnamed)).to eq [motif_unnamed, motif_unnamed] }
  end

  context 'with specified pattern' do
    let(:motif_splitter) { Bioinform::MotifSplitter.new(start_motif_pattern: /^NA\s+\w+$/, splitter_pattern: /^\/\/\s$/) }

    let(:input_1) {
      "NA  motif_1\n" +
      "P0  A C G T\n" +
      "P1  0 1 2 3\n" +
      "P2  4 5 6 7"
    }

    let(:input_2) {
      "NA  motif_2\n" +
      "P0  A C G T\n" +
      "P1  1 2 3 4\n" +
      "P2  5 6 7 8\n" +
      "P3  9 10 11 12"
    }

    let(:input_3) {
      "NA  motif_3\n" +
      "P0  A C G T\n" +
      "P1  2 3 4 5\n" +
      "P2  6 7 8 9"
    }

    # this input doesn't have pattern of start motif
    let(:input_wo_name) {
      "P0  A C G T\n" +
      "P1  3 4 5 6\n" +
      "P2  7 8 9 10"
    }

    specify do
      input = "//\n" +
              input_1 + "\n" +
              "//\n" +
              "//\n" +
              input_2 + "\n" +
              "//\n" +
              input_3
      expect(motif_splitter.split(input)).to eq [input_1, input_2, input_3]
    end

    specify 'splitter (w/o motif starter) is enough to split motifs' do
      input = input_1 + "\n" +
              "//\n" +
              input_wo_name
      expect(motif_splitter.split(input)).to eq [input_1, input_wo_name]
    end

    specify 'motif starter (w/o splitter) is enough to split motifs' do
      input = input_1 + "\n" +
              input_2
      expect(motif_splitter.split(input)).to eq [input_1, input_2]
    end
  end
end
