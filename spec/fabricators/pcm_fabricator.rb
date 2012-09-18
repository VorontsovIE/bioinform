Fabricator(:pcm, from: Bioinform::PCM) do
  initialize_with{ Bioinform::PCM.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PCM_name') }
end

Fabricator(:pcm_1, from: :pcm) do
  matrix [[0,1,2,3],[4,5,6,7]]
  name 'motif_1'
end
Fabricator(:pcm_2, from: :pcm) do
  matrix [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
  name 'motif_2'
end
Fabricator(:pcm_3, from: :pcm) do
  matrix [[2,3,4,5],[6,7,8,9]]
  name 'motif_3'
end