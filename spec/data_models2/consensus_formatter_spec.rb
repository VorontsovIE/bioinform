require 'bioinform/data_models/pm'
require 'bioinform/formatters/consensus_formatter'

describe Bioinform::ConsensusFormatter do
  let(:pm) { Bioinform::MotifModel::PM.new([[10,30,10,28], [30,16,16,16], [12,30,10,26], [26,27,27,1]]) }

  specify('.new without a block raises error') { expect{ Bioinform::ConsensusFormatter.new }.to raise_error Bioinform::Error }

  context 'custom formatter' do
    let(:formatter){ Bioinform::ConsensusFormatter.new{|pos, el, ind| (pos.max - el) < pos.max * 0.1 } }
    specify{ expect(formatter.format_string(pm)).to eq 'YACV' }
  end

  context 'standard formatter' do
    let(:formatter){ Bioinform::ConsensusFormatter.by_maximal_elements }
    specify{ expect(formatter.format_string(pm)).to eq 'CACS' }
  end

  specify do
    expect{|b|
      Bioinform::ConsensusFormatter.new(&b).format_string(pm)
      }.to yield_successive_args( *([ [[10,30,10,28],10,0],     # col,el,ind
                                      [[10,30,10,28],30,1] ] +  # col,el,ind
                                      [Array]*14 ) )            # rest triples
  end
end
