Fabricator(:ppm, class_name: Bioinform::PPM) do
  initialize_with{ Bioinform::PPM.new(matrix: [[0.2, 0.3, 0.3, 0.2],[0.7, 0.2, 0.0, 0.1]]) }
  name 'PPM_name'
end

# It has the same name as original pcm because PCM#to_ppm doesn't change the name
Fabricator(:ppm_by_pcm, class_name: Bioinform::PPM) do
  initialize_with{ Fabricate(:pcm).to_ppm }
end

Fabricator(:ppm_pcm_divided_by_count, from: :ppm) do
# this matrix should be initialized manually - it's used for spec checking PCM#to_ppm
  matrix [[1.0/7.0, 2.0/7.0, 3.0/7.0, 1.0/7.0], [4.0/7.0, 0.0/7.0, 1.0/7.0, 2.0/7.0]]
end