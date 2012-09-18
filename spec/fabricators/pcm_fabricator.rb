Fabricator(:pcm, from: Bioinform::PCM) do
  initialize_with{ Bioinform::PCM.new(matrix: [[1, 2, 3, 1],[4, 0, 1, 2]], name: 'PCM_name') }
end

Fabricator(:pcm_with_floats, from: :pcm) do
  matrix [[1, 2.3, 3.2, 1],[4.4, 0.1, 0.9, 2.1]]
end

Fabricator(:completely_different_pcm, from: :pcm) do
  matrix [[101,207,138,248],[85,541,7,61]]
  name 'PCM_another_name'
end

Fabricator(:pcm_1, from: :pcm) do
  matrix [[7,10,2,3],[4,5,6,7]]
  name 'motif_1'
end
Fabricator(:pcm_2, from: :pcm) do
  matrix [[5,7,4,6],[11,6,2,3],[10,3,3,6]]
  name 'motif_2'
end
Fabricator(:pcm_3, from: :pcm) do
  matrix [[3,4,1,14],[9,2,9,2]]
  name 'motif_3'
end