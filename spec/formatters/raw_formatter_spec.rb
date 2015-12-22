require 'bioinform/formatters/motif_formatter'
require 'bioinform/data_models/pm'

describe Bioinform::MotifFormatter do
  let(:matrix) { [[1,2.345,6.7,8.99],
                  [10,11.123,-15.678,16]] }
  let(:motif) { Bioinform::MotifModel::PM.new(matrix) }
  let(:default_matrix_string) { "1	2.345	6.7	8.99\n"+
                                "10	11.123	-15.678	16" }

  context 'with default configuration' do
    let(:formatter) { Bioinform::MotifFormatter.new }
    specify { expect(formatter.with_name).to eq :auto }
    specify { expect(formatter.nucleotides_in).to eq :columns }
    specify { expect(formatter.precision).to be_falsy }
    specify { expect(formatter.with_nucleotide_header).to eq false }
    specify { expect(formatter.with_position_header).to eq false }
  end

  context 'with with_name equal to false' do
    let(:formatter) { Bioinform::MotifFormatter.new(with_name: false) }
    specify { expect( formatter.format(motif) ).to eq default_matrix_string }
    specify { expect( formatter.format(motif.named('Stub name')) ).to eq default_matrix_string }
  end
  context 'with with_name equal to true' do
    let(:formatter) { Bioinform::MotifFormatter.new(with_name: true) }
    specify { expect{ formatter.format(motif) }.to raise_error(Bioinform::Error) }
    specify { expect( formatter.format(motif.named('')) ).to eq ">\n" +
                                                              default_matrix_string }
    specify { expect( formatter.format(motif.named('Stub name')) ).to eq ">Stub name\n" +
                                                                       default_matrix_string }
  end
  context 'with with_name equal to :auto' do
    let(:formatter) { Bioinform::MotifFormatter.new(with_name: :auto) }
    specify { expect( formatter.format(motif) ).to eq default_matrix_string }
    specify { expect( formatter.format(motif.named('')) ).to eq default_matrix_string }
    specify { expect( formatter.format(motif.named('Stub name')) ).to eq ">Stub name\n" +
                                                                      default_matrix_string }
  end
  context 'with with_name value different from true/false/:auto' do
    specify{ expect { Bioinform::MotifFormatter.new(with_name: :somewhat) }.to raise_error(Bioinform::Error) }
  end

  context 'with nucleotides_in :columns' do
    let(:formatter) { Bioinform::MotifFormatter.new(nucleotides_in: :columns) }
    specify { expect( formatter.format(motif) ).to eq "1	2.345	6.7	8.99\n" +
                                                      "10	11.123	-15.678	16" }
  end
  context 'with nucleotides_in :rows' do
    let(:formatter) { Bioinform::MotifFormatter.new(nucleotides_in: :rows) }
    specify { expect( formatter.format(motif) ).to eq "1	10\n" +
                                                      "2.345	11.123\n" +
                                                      "6.7	-15.678\n" +
                                                      "8.99	16" }
  end
  context 'with nucleotides_in not equal to :rows or :columns' do
    specify { expect{ Bioinform::MotifFormatter.new(nucleotides_in: :somewhat) }.to raise_error(Bioinform::Error) }
  end

  context 'with precision equal to false' do
    let(:formatter) { Bioinform::MotifFormatter.new(precision: false) }
    specify { expect( formatter.format(motif) ).to eq "1	2.345	6.7	8.99\n" +
                                                      "10	11.123	-15.678	16" }
  end
  context 'with precision equal to a number' do
    let(:formatter) { Bioinform::MotifFormatter.new(precision: 3) }
    specify { expect( formatter.format(motif) ).to eq "1	2.35	6.7	8.99\n" +
                                                      "10	11.1	-15.7	16" }
  end

  context 'with nucleotide header' do
    context 'with nucleotides in columns' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_nucleotide_header: true, nucleotides_in: :columns) }
      specify { expect( formatter.format(motif) ).to eq "A	C	G	T\n" +
                                                        "1	2.345	6.7	8.99\n" +
                                                        "10	11.123	-15.678	16" }

    end
    context 'with nucleotides in rows' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_nucleotide_header: true, nucleotides_in: :rows) }
      specify { expect( formatter.format(motif) ).to eq "A	1	10\n" +
                                                        "C	2.345	11.123\n" +
                                                        "G	6.7	-15.678\n" +
                                                        "T	8.99	16" }
    end
  end

  context 'with position header' do
    context 'with nucleotides in columns' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_position_header: true, nucleotides_in: :columns) }
      let(:long_motif) { Bioinform::MotifModel::PM.new([[1,2,3,4]] * 12) }
      specify { expect( formatter.format(motif) ).to eq "01	1	2.345	6.7	8.99\n" +
                                                        "02	10	11.123	-15.678	16" }
      specify { expect( formatter.format(long_motif) ).to eq  "01	1	2	3	4\n" +
                                                              "02	1	2	3	4\n" +
                                                              "03	1	2	3	4\n" +
                                                              "04	1	2	3	4\n" +
                                                              "05	1	2	3	4\n" +
                                                              "06	1	2	3	4\n" +
                                                              "07	1	2	3	4\n" +
                                                              "08	1	2	3	4\n" +
                                                              "09	1	2	3	4\n" +
                                                              "10	1	2	3	4\n" +
                                                              "11	1	2	3	4\n" +
                                                              "12	1	2	3	4" }
    end
    context 'with nucleotides in rows' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_position_header: true, nucleotides_in: :rows) }
      specify { expect( formatter.format(motif) ).to eq "01	02\n" +
                                                        "1	10\n" +
                                                        "2.345	11.123\n" +
                                                        "6.7	-15.678\n" +
                                                        "8.99	16" }
    end
  end

  context 'with both headers' do
    context 'with nucleotides in columns' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_position_header: true, with_nucleotide_header: true, nucleotides_in: :columns) }
      specify { expect( formatter.format(motif) ).to eq "	A	C	G	T\n" +
                                                        "01	1	2.345	6.7	8.99\n" +
                                                        "02	10	11.123	-15.678	16" }
    end
    context 'with nucleotides in rows' do
      let(:formatter) { Bioinform::MotifFormatter.new(with_position_header: true, with_nucleotide_header: true, nucleotides_in: :rows) }
      specify { expect( formatter.format(motif) ).to eq "	01	02\n" +
                                                        "A	1	10\n" +
                                                        "C	2.345	11.123\n" +
                                                        "G	6.7	-15.678\n" +
                                                        "T	8.99	16" }
    end
  end

  context 'on different alphabet' do
    let(:matrix_15) { [[1,2,3,1.567,  12,-11,12,0,-1.1,0.6,  0.4,0.321,0.11,-1.23, 2.0],
                       [0,0,0,0,       0,0,0,0,0,0, 0,0,0,0, 0]] }
    let(:motif) { Bioinform::MotifModel::PM.new(matrix_15, alphabet: Bioinform::IUPACAlphabet) }

    specify {
      expect( Bioinform::MotifFormatter.new.format(motif) )
        .to eq  "1	2	3	1.567	12	-11	12	0	-1.1	0.6	0.4	0.321	0.11	-1.23	2.0\n" +
                "0	0	0	0	0	0	0	0	0	0	0	0	0	0	0"
    }
    specify {
      expect( Bioinform::MotifFormatter.new(with_nucleotide_header: true).format(motif) )
        .to eq  "A	C	G	T	M	R	W	S	Y	K	V	H	D	B	N\n" +
                "1	2	3	1.567	12	-11	12	0	-1.1	0.6	0.4	0.321	0.11	-1.23	2.0\n" +
                "0	0	0	0	0	0	0	0	0	0	0	0	0	0	0"
    }
    specify {
      expect( Bioinform::MotifFormatter.new(with_nucleotide_header: true, nucleotides_in: :rows).format(motif) )
        .to eq  "A	1	0\n" +
                "C	2	0\n" +
                "G	3	0\n" +
                "T	1.567	0\n" +
                "M	12	0\n" +
                "R	-11	0\n" +
                "W	12	0\n" +
                "S	0	0\n" +
                "Y	-1.1	0\n" +
                "K	0.6	0\n" +
                "V	0.4	0\n" +
                "H	0.321	0\n" +
                "D	0.11	0\n" +
                "B	-1.23	0\n" +
                "N	2.0	0"
    }
  end
end
