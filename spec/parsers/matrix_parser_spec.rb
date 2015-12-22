require 'bioinform/parsers/matrix_parser'

describe Bioinform::MatrixParser do
  specify { expect{ Bioinform::MatrixParser.new(nucleotides_in: :somewhat) }.to raise_error(Bioinform::Error) }

  context 'with default options' do
    subject(:parser) { Bioinform::MatrixParser.new }
    specify { expect(parser.has_name).to eq :auto }
    specify { expect(parser.has_header_row).to eq false }
    specify { expect(parser.has_header_column).to eq false }
    specify { expect(parser.nucleotides_in).to eq :auto }
    specify { expect(parser.fix_nucleotides_number).to eq 4 }

    specify { expect(parser.name_pattern).to match ">Motif_name" }
    specify { expect(parser.name_pattern).to match ">Motif name" }
    specify { expect(parser.name_pattern).to match "> Motif name" }
    specify { expect(parser.name_pattern).to match "Motif name" }
    specify { expect(parser.name_pattern).to match "Motif name\tother info" }

    specify { expect(parser.name_pattern.match(">Motif_name")[:name]).to eq "Motif_name" }
    specify { expect(parser.name_pattern.match(">Motif name")[:name]).to eq "Motif name" }
    specify { expect(parser.name_pattern.match("> Motif name")[:name]).to eq "Motif name" }
    specify { expect(parser.name_pattern.match("Motif name")[:name]).to eq "Motif name" }
    specify { expect(parser.name_pattern.match("Motif name\tother info")[:name]).to eq "Motif name" }
  end

  context 'parser having name' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns,has_name: true) }
    let(:input) {">PM name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }

    specify 'trims empty lines' do
      expect( parser.parse!("\n   \t  \n" + input + "\n\n") ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} )
    end
  end
  context 'parser having neither name nor header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_name: false) }
    let(:input_allowed) {"1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed) {">PM Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed_2) {"A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed_3) {"##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input_allowed) ).to eq( {name: nil, matrix: [[1,2,3,4],[11,12,13,14]]} ) }
    specify { expect{ parser.parse!(input_not_allowed) }.to raise_error(Bioinform::Error) }
    specify { expect{ parser.parse!(input_not_allowed_2) }.to raise_error(Bioinform::Error) }
    specify { expect{ parser.parse!(input_not_allowed_3) }.to raise_error(Bioinform::Error) }
  end
  context 'with has_name equal to :auto parser can either have name or not' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_name: :auto) }
    let(:input_without_name) {"1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_with_name) {">PM Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_with_bad_name) {"-Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input_without_name) ).to eq( {name: nil, matrix: [[1,2,3,4],[11,12,13,14]]} ) }
    specify { expect( parser.parse!(input_with_name) ).to eq( {name: 'PM Name', matrix: [[1,2,3,4],[11,12,13,14]]} ) }
    specify { expect{ parser.parse!(input_with_bad_name) }.to raise_error(Bioinform::Error) }
  end
  context 'parser having name and header row' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_name: true, has_header_row: true) }
    let(:input) {">PM name\n" + "A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser having header row' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_name: false, has_header_row: true) }
    let(:input) {"A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: nil, matrix: [[1,2,3,4],[11,12,13,14]]} ) }
    specify { expect{ parser.parse!("Motif name\n" + input) }.to raise_error(Bioinform::Error) }
  end
  context 'parser having header column' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_header_column: true) }
    let(:input) {">PM name\n" + "##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser having both headers' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :columns, has_header_row: true, has_header_column: true) }
    let(:input) {">PM name\n" + "X\tA\tC\tG\tT\n" + "##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end

  context 'parser for transposed matrix' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows) }
    let(:input) {">PM name\n" + "1\t11\n" + "2\t12\n" + "3\t13\n" + "4\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: 'PM name', matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser for transposed matrix with row header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_row: true) }
    let(:input) {">PM name\n" + "##01\t##02\n" + "1\t11\n" + "2\t12\n" + "3\t13\n" + "4\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser for transposed matrix with column header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_column: true) }
    let(:input) {">PM name\n" + "A\t1\t11\n" + "C\t2\t12\n" + "G\t3\t13\n" + "T\t4\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser for transposed matrix with both header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_column: true, has_header_row: true) }
    let(:input) {">PM name\n" + "X\t##01\t##02\n" + "A\t1\t11\n" + "C\t2\t12\n" + "G\t3\t13\n" + "T\t4\t14" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end

  context 'parser having custom name pattern' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true, name_pattern: /^NA>(?<name>.+)$/) }
    let(:input_allowed) {"NA>Motif name\tother info\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed) {"Motif name\tother info\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input_allowed) ).to eq( {name: "Motif name\tother info", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
    specify { expect{ parser.parse!(input_not_allowed) }.to raise_error(Bioinform::Error) }
  end

  context 'parser reducing number of nucleotides' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true) }
    let(:input) {">PM name\n" + "1\t2\t3\t4\t5\n" + "11\t12\t13\t14\t15" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser for transposed matrix reducing number of nucleotides' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows) }
    let(:input) {">PM name\n" + "1\t11\n" + "2\t12\n" + "3\t13\n" + "4\t14\n" + "5\t15"}
    specify { expect( parser.parse!(input) ).to eq( {name: 'PM name', matrix: [[1,2,3,4],[11,12,13,14]]} ) }
  end
  context 'parser not reducing number of nucleotides' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true, fix_nucleotides_number: false) }
    let(:input) {">PM name\n" + "1\t2\t3\t4\t5\n" + "11\t12\t13\t14\t15" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3,4,5],[11,12,13,14,15]]} ) }
  end
  context 'parser reducing number of nucleotides to a non-standard one' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true, fix_nucleotides_number: 3) }
    let(:input) {">PM name\n" + "1\t2\t3\t4\t5\n" + "11\t12\t13\t14\t15" }
    specify { expect( parser.parse!(input) ).to eq( {name: "PM name", matrix: [[1,2,3],[11,12,13]]} ) }
  end
  context 'parser which hasn\'t enough number of nucleotides' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true, fix_nucleotides_number: 4) }
    let(:input) {">PM name\n" + "1\t2\t3\n" + "11\t12\t13" }
    specify { expect{ parser.parse!(input) }.to raise_error(Bioinform::Error) }
  end

  context 'parser with auto transposition' do
    let(:input_not_transposed) {">PM Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_transposed) {">PM Name\n" + "1\t11\n" + "2\t12\n" + "3\t13\n"  + "4\t14"}
    let(:input_4x4) {">PM Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14"}
    context 'with fixed nucleotides number' do
      subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :auto, fix_nucleotides_number: 4) }
      specify { expect(parser.parse(input_not_transposed)).to eq({name:'PM Name', matrix: [[1,2,3,4],[11,12,13,14]]}) }
      specify { expect(parser.parse(input_transposed)).to eq({name:'PM Name', matrix: [[1,2,3,4],[11,12,13,14]]}) }
      specify { expect(parser.parse(input_4x4)).to eq({name:'PM Name', matrix: [[1,2,3,4],[11,12,13,14],[1,2,3,4],[11,12,13,14]]}) }
    end
    context 'with non fixed nucleotides number' do
      subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :auto, fix_nucleotides_number: false) }
      specify { expect(parser.parse(input_not_transposed)).to eq({name:'PM Name', matrix: [[1,2,3,4],[11,12,13,14]]}) }
      specify { expect(parser.parse(input_transposed)).to eq({name:'PM Name', matrix: [[1,11],[2,12],[3,13],[4,14]]}) }
      specify { expect(parser.parse(input_4x4)).to eq({name:'PM Name', matrix: [[1,2,3,4],[11,12,13,14],[1,2,3,4],[11,12,13,14]]}) }
    end
  end

  context 'FANTOM-formatted motifs' do
    let(:parser) do
      Bioinform::MatrixParser.new( has_name: true, name_pattern: /^NA\s+(?<name>.+)$/,
                        has_header_row: true, has_header_column: true, nucleotides_in: :columns,
                        reduce_to_n_nucleotides: 4 )
    end

    specify 'parse strings in FANTOM format' do
      input = "NA  PM_name\n" +
              "P0  A C G T\n" +
              "P1  1 2 3 4\n" +
              "P2  5 6 7 8"
      expect(parser.parse(input)).to eq({matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'})
    end


    specify 'ignores additional columns' do
      input = "NA  PM_name\n" +
              "P0  A C G T S P\n" +
              "P1  1 2 3 4 5 10\n" +
              "P2  5 6 7 8 5 11"
      expect(parser.parse(input)).to eq({matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'})
    end

    specify 'parses string with more than 10 positions(2-digit row numbers)' do
      input = "NA  PM_name\n" +
              "P0  A C G T\n" +
              "P1  1 2 3 4\n" +
              "P2  5 6 7 8\n" +
              "P3  1 2 3 4\n" +
              "P4  5 6 7 8\n" +
              "P5  1 2 3 4\n" +
              "P6  5 6 7 8\n" +
              "P7  1 2 3 4\n" +
              "P8  5 6 7 8\n" +
              "P9  1 2 3 4\n" +
              "P10 5 6 7 8\n" +
              "P11 1 2 3 4\n" +
              "P12 5 6 7 8"
      expect(parser.parse(input)).to eq({matrix: [[1,2,3,4],[5,6,7,8]]*6, name: 'PM_name'})
    end

    good_cases = {
      'Nx4 string' => {input: "1 2 3 4\n5 6 7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      '4xN string' => {input: "1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with name' => {input: "PM_name\n1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'} },
      'string with name (with introduction sign)' => {input: ">\t PM_name\n1 5\n2 6\n3 7\n 4 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name'} },
      'string with name (with special characters)' => {input: "Testmatrix_first:subname+sub-subname\n1 5\n2 6\n3 7\n 4 8",
                                                       result: {matrix: [[1,2,3,4],[5,6,7,8]], name: 'Testmatrix_first:subname+sub-subname'} },
      'string with float numerics' => {input: "1.23 4.56 7.8 9.0\n9 -8.7 6.54 -3210",  result: {matrix: [[1.23, 4.56, 7.8, 9.0],[9, -8.7, 6.54, -3210]], name: nil} },
      'string with exponents' => {input: "123e-2 0.456e+1 7.8 9.0\n9 -87000000000E-10 6.54 -3.210e3",  result: {matrix: [[1.23, 4.56, 7.8, 9.0],[9, -8.7, 6.54, -3210]], name: nil} },
      'string with multiple spaces and tabs' => {input: "1 \t\t 2 3 4\n 5 6   7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with preceeding and terminating newlines' => {input: "\n\n\t 1 2 3 4\n5 6 7 8  \n\t\n", result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
      'string with windows crlf' => {input: "1 2 3 4\r\n5 6 7 8",  result: {matrix: [[1,2,3,4],[5,6,7,8]], name: nil} },
    }

    bad_cases = {
      'string with non-numeric input' =>  {input: "1.23 4.56 78aaa 9.0\n9 -8.7 6.54 -3210" },
      'string with non-numeric input at the end of line' =>  {input: "1.23 4.56 78 9.0aaa\n9 -8.7 6.54 -3210" },
      'string with non-numeric input at a separate line' =>  {input: "1.23 4.56 78 9.0\naaa\n9 -8.7 6.54 -3210" },
      'string with empty exponent sign' => {input: "1.23 4.56 7.8 9.0\n 9e -8.7 6.54 3210" }
    }

    parser_specs(Bioinform::MatrixParser.new, good_cases, bad_cases)
  end
end
