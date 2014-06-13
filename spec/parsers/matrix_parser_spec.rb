require 'bioinform/parsers/matrix_parser'

describe Bioinform::MatrixParser do
  specify { expect{ Bioinform::MatrixParser.new(nucleotides_in: :somewhat) }.to raise_error Bioinform::Error }

  context 'with default options' do
    subject(:parser) { Bioinform::MatrixParser.new }
    specify { expect(parser.has_name).to eq true }
    specify { expect(parser.has_header_row).to eq false }
    specify { expect(parser.has_header_column).to eq false }
    specify { expect(parser.nucleotides_in).to eq :columns }

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
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true) }
    let(:input) {">PM name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser having neither name nor header' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: false) }
    let(:input_allowed) {"1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed) {">PM Name\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed_2) {"A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed_3) {"##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input_allowed) ).to eq( OpenStruct.new({name: nil, matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
    specify { expect{ parser.parse!(input_not_allowed) }.to raise_error Bioinform::Error }
    specify { expect{ parser.parse!(input_not_allowed_2) }.to raise_error Bioinform::Error }
    specify { expect{ parser.parse!(input_not_allowed_3) }.to raise_error Bioinform::Error }
  end
  context 'parser having name and header row' do
    subject(:parser) { Bioinform::MatrixParser.new(has_header_row: true) }
    let(:input) {">PM name\n" + "A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser having header row' do
    subject(:parser) { Bioinform::MatrixParser.new(has_header_row: true) }
    let(:input) {">PM name\n" + "A\tC\tG\tT\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
    # specify { expect{ parser.parse!(input_with_name_with_header) }.to raise_error Bioinform::Error }
  end
  context 'parser having header column' do
    subject(:parser) { Bioinform::MatrixParser.new(has_header_column: true) }
    let(:input) {">PM name\n" + "##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser having both headers' do
    subject(:parser) { Bioinform::MatrixParser.new(has_header_row: true, has_header_column: true) }
    let(:input) {">PM name\n" + "X\tA\tC\tG\tT\n" + "##01\t1\t2\t3\t4\n" + "##02\t11\t12\t13\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end

  context 'parser for transposed matrix' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows) }
    let(:input) {">PM name\n" + "1\t11\n" + "2\t12\n" + "3\t13\n" + "4\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: 'PM name', matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser for transposed matrix with row header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_row: true) }
    let(:input) {">PM name\n" + "##01\t##02\n" + "1\t11\n" + "2\t12\n" + "3\t13\n" + "4\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser for transposed matrix with column header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_column: true) }
    let(:input) {">PM name\n" + "A\t1\t11\n" + "C\t2\t12\n" + "G\t3\t13\n" + "T\t4\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end
  context 'parser for transposed matrix with both header' do
    subject(:parser) { Bioinform::MatrixParser.new(nucleotides_in: :rows, has_header_column: true, has_header_row: true) }
    let(:input) {">PM name\n" + "X\t##01\t##02\n" + "A\t1\t11\n" + "C\t2\t12\n" + "G\t3\t13\n" + "T\t4\t14" }
    specify { expect( parser.parse!(input) ).to eq( OpenStruct.new({name: "PM name", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
  end

  context 'parser having custom name pattern' do
    subject(:parser) { Bioinform::MatrixParser.new(has_name: true, name_pattern: /^NA>(?<name>.+)$/) }
    let(:input_allowed) {"NA>Motif name\tother info\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    let(:input_not_allowed) {"Motif name\tother info\n" + "1\t2\t3\t4\n" + "11\t12\t13\t14" }
    specify { expect( parser.parse!(input_allowed) ).to eq( OpenStruct.new({name: "Motif name\tother info", matrix: [[1,2,3,4],[11,12,13,14]]}) ) }
    specify { expect{ parser.parse!(input_not_allowed) }.to raise_error Bioinform::Error }
  end
end
