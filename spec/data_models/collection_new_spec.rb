=begin
describe Collection do
  subject{ collection }
  let(:pcm) { Fabricate(:pcm) }
  let(:pcm_1) { Fabricate(:pcm_1) }
  let(:pcm_2) { Fabricate(:pcm_2) }
  let(:pcm_3) { Fabricate(:pcm_3) }
  let(:pwm_by_pcm_1) { pcm_1.to_pwm }
  let(:pwm_by_pcm_2) { pcm_2.to_pwm }
  let(:pwm_by_pcm_3) { pcm_3.to_pwm }
  let(:pwm) { Fabricate(:pwm) }
  context 'when collection has 3 pcm-motifs and 1 pwm-motif' do
    let(:collection) { Fabricate :collection_with_3_pcms_and_1_pwm}
    it 'is iteratable, yielding OpenStructs with corresponding to motif type fields' do
      expect{|b| subject.each(&b) }.to yield_successive_args(OpenStruct.new(pcm: pcm_1),
                                                        OpenStruct.new(pcm: pcm_2),
                                                        OpenStruct.new(pcm: pcm_3),
                                                        OpenStruct.new(pwm: pwm)) 
    end
  end
  context '#size' do
    subject{ collection.size }
    context 'when collection has 3 pcm-motifs' do
      let(:collection) { Fabricate :collection_with_3_pcms}
      it { should == 3}
    end
    context 'when collection has 3 pcm-motifs and 1 pwm-motif' do
      let(:collection) { Fabricate :collection_with_3_pcms_and_1_pwm}
      it { should == 4}
    end
  end
  
  context '#pcm' do
    subject{ collection.pcm }
    context 'when collection has 3 pcm-motifs' do
      let(:collection) { Fabricate :collection_with_3_pcms}
      it { should respond_to :[] }
      it 'contains pcms at according positions' do
        subject[0].should == pcm_1
        subject[1].should == pcm_2
        subject[2].should == pcm_3
      end
      it 'is iteratable yielding pcms' do
        expect{|b| subject.each(&b)}.to yield_successive_args(pcm_1, pcm_2, pcm_3)
      end
    end
    context 'when collection has 3 pcm-motifs and 1 pwm-motif' do
      let(:collection) { Fabricate :collection_with_3_pcms_and_1_pwm}
      it { should respond_to :[] }
      it 'contains pcms at according positions' do
        subject[0].should == pcm_1
        subject[1].should == pcm_2
        subject[2].should == pcm_3
      end
      it 'gives nil on place of pwm' do
        subject[3].should be_nil
      end
      it 'is iteratable yielding pcms where they are and nils for a pwm' do
        expect{|b| subject.each(&b)}.to yield_successive_args(pcm_1, pcm_2, pcm_3, nil)
      end
    end
  end
  
  
  context '#pwm' do
    subject{ collection.pwm }
    context 'when collection has 3 pcm-motifs' do
      let(:collection) { Fabricate :collection_with_3_pcms}
      
      it { should respond_to :[] }
      it 'contains pwms correspondng to pcms at according positions' do
        subject[0].should == pwm_by_pcm_1
        subject[1].should == pwm_by_pcm_2
        subject[2].should == pwm_by_pcm_3
      end
      it 'is iteratable yielding pwms corresponding to pcms' do
        expect{|b| subject.each(&b)}.to yield_successive_args(pwm_by_pcm_1, pwm_by_pcm_2, pwm_by_pcm_3)
      end
    end
    
    context 'when collection has 3 pcm-motifs and 1 pwm-motif' do
      let(:collection) { Fabricate :collection_with_3_pcms_and_1_pwm}
      it { should respond_to :[] }
      it 'contains pwms corresponding to pcms at according positions' do
        subject[0].should == pwm_by_pcm_1
        subject[1].should == pwm_by_pcm_2
        subject[2].should == pwm_by_pcm_3
      end
      it 'gives pwm on place where it is' do
        subject[3].should == pwm
      end
      it 'is iteratable yielding pwms where they are and pwms corresponding to pcms for pcms' do
        expect{|b| subject.each(&b)}.to yield_successive_args(pwm_by_pcm_1, pwm_by_pcm_2, pwm_by_pcm_3, pwm)
      end
    end
  end
  
  describe '#name' do
    context 'when collection created with parameter name' do
      let(:collection) { described_class.new(name: 'Collection name') }
      it 'equals to specified parameter' do
        subject.name.should == 'Collection name'
      end
    end
    context 'when name is specified with #name=' do
      let(:collection) { described_class.new }
      it 'equals to specified parameter' do
        subject.name= 'Specified name'
        subject.name.should == 'Specified name'
      end
    end
  end
  
  describe '#<< operator' do
    let(:collection) {described_class.new}
    it 'should add motif to a collection' do
      subject << pcm
      subject.size == 1
      subject << pcm_1
      subject.size == 2
      subject << pwm
      subject.size == 3
    end
  end

  describe '#add_motif' do
    context 'without info' do
      it 'should behave like #<< operator' do
        collection_1 = described_class.new
        collection_1 << pcm << pwm
        
        collection_2 = described_class.new
        collection_2.add_motif(pcm).add_motif(pwm)
        
        collection_1.should == collection_2
      end
    end
    
    context 'with info' do
      let(:collection) {described_class.new}
      it 'should add motif' do
        subject.add_motif(pcm, motif_name: 'motif-name', stub_parameter: 'stub')
        subject[0].pcm.should == pcm
        subject[0].motif_name.should == 'motif-name'
        subject[0].stub_parameter.should == 'stub'
      end
    end
  end
  
end


#
# collection << pcm << pwm
# collection[0].pcm == collection.pcm[0]
# collection[1].pcm == nil
# collection.pcm[1] == nil
#
# collection[1].pwm == nil
# collection.pwm[1] == pwm

#

=begin
collection = Collection.new
collection << pcm1 << pcm2 << pcm3

collection[0].pcm == collection.pcm[0] == pcm1
collection[1].pcm == collection.pcm[1] == pcm2

collection[0].has_key?(:pwm) is false
collection[0].pwm == collection[0].pcm.to_pwm

collection[0].pwm = pwm3
collection[0].has_key?(:pwm) is true
collection[0].pwm == pwm3

collection[0].threshold.should_not be
collection[0].should_not has_key(:threshold)

collection[0].threshold = 123
collection[0].threshold.should == 123
collection[0].should has_key(:threshold)

collection[0].set_parameters(threshold: 234)
collection[0].threshold.should == 234
collection[0].should has_key(:threshold)

collection.pcm.each{|pcm|  }
collection.each(:pcm){|pcm| }

collection.pwm.each{|pwm|  }
collection.each(:pwm){|pwm| }

collection.each{|motif_info| motif_info.pcm; motif_info.pwm; motif_info.threshold}
collection.each_with(:pcm, :threshold){|pcm, threshold|  }

?? collection.each(:threshold){|threshold| }

?? collection.each_info{|infos| }
?? collection.pcm.each_with_info{|pcm, info| }


collection << pwm
collection.last.pwm == pwm
collection.last.pcm == nil

collection << pcm
collection.last.pcm == pcm
collection.last.pwm == pcm.to_pwm

collection.each(:pcm).to_a #=> [pcm1, pcm2, pcm3, nil, pcm]
collection.each(:pwm).to_a #=> [pcm1.to_pwm, pcm2.to_pwm, pcm3.to_pwm, pwm, pcm.to_pwm]

collection.add_motif(pcm: pcm, threshold: 12.345)

collection.find_by(:name)
collection.name ?==?  collection.pcm.name 
=end