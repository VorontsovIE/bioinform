require_relative '../spec_helper'
require 'bioinform/cli'

def compare_positions(pos_1, pos_2, eps: 1e-6)
  pos_1.zip(pos_2).all?{|el_1, el_2|
    (el_1 - el_2).abs <= eps
  }
end

def compare_matrices(matrix_1, matrix_2, eps: 1e-6)
  matrix_1.length == matrix_2.length && \
  matrix_1.zip(matrix_2).all?{|pos_1, pos_2|
    compare_positions(pos_1, pos_2, eps: eps)
  }
end

def compare_models_in_files(file_1, file_2, klass: Bioinform::MotifModel::PM, eps: 1e-6)
  pm_1 = klass.from_file(file_1)
  pm_2 = klass.from_file(file_2)
  pm_1.name == pm_2.name && compare_matrices(pm_1.matrix, pm_2.matrix)
end

describe Bioinform::CLI do
  describe '.change_folder_and_extension' do
    it 'should change extension and folder' do
      extend Bioinform::CLI::Helpers
      expect( change_folder_and_extension('test.pcm', 'pwm', '.') ).to eq './test.pwm'
      expect( change_folder_and_extension('test.pcm', 'pat', 'pwm_folder') ).to eq 'pwm_folder/test.pat'
      expect( change_folder_and_extension('pcm/test.pcm', 'pat', 'pwm_folder') ).to eq 'pwm_folder/test.pat'
      expect( change_folder_and_extension('test.pcm', 'pat', '../pwm_folder') ).to eq '../pwm_folder/test.pat'
    end
  end
end
