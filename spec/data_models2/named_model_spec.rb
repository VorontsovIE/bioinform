require 'bioinform/data_models_2/pwm'
require 'bioinform/data_models_2/named_model'

describe Bioinform::MotifModel::NamedModel do
  context 'with PWM-model' do
    let(:pwm) { Bioinform::MotifModel::PWM.new([[1,2,3,4],[10,20,30,40]]) }
    let(:name) { 'pwm name' }
    let(:named_pwm) { Bioinform::MotifModel::NamedModel.new(pwm, name) }
    specify { expect(named_pwm.model).to eq pwm }
    specify { expect(named_pwm.name).to eq name }

    context 'being sent a method returning a result of model type (class is Bioinform::MotifModel::*)' do
      subject { named_pwm.reversed }
      specify 'should return a named model' do
        expect(subject).to be_kind_of Bioinform::MotifModel::NamedModel
      end
      specify 'resulting named model should wrap actual result' do
        expect(subject.model).to eq pwm.reversed
      end
      specify 'resulting named model should have the same name as callee' do
        expect(subject.name).to eq name
      end
    end

    context 'being sent a method returning a result of common, non-model type (class is not Bioinform::MotifModel::*)' do
      specify 'should return original result' do
        expect(named_pwm.length).to eq pwm.length
      end
    end

    describe '#==' do
      let(:another_pwm) { Bioinform::MotifModel::PWM.new([[4,3,2,1],[-100,-500,-500,-100]]) }
      specify { expect(named_pwm).to eq Bioinform::MotifModel::NamedModel.new(pwm, name) }
      specify { expect(named_pwm).not_to eq Bioinform::MotifModel::NamedModel.new(pwm, 'Another name') }
      specify { expect(named_pwm).not_to eq Bioinform::MotifModel::NamedModel.new(another_pwm, name) }
      specify { expect(named_pwm).not_to eq Bioinform::MotifModel::NamedModel.new(another_pwm, 'Another name') }
    end

    specify { expect(named_pwm.to_s).to eq ">pwm name\n" + "1\t2\t3\t4\n" + "10\t20\t30\t40" }
  end
end
