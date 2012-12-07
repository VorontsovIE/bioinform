Fabricator(:pm, class_name: Bioinform::PM) do
  initialize_with{ Bioinform::PM.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PM_name') }
end

Fabricator(:pm_unnamed, from: :pm) do
  name nil
end


Fabricator(:pm_first, from: :pm) do
  name 'PM_first'
end

Fabricator(:pm_second, from: :pm) do
  matrix [[15,16,17,18],[11,21,31,41]]
  name 'PM_second'
end


Fabricator(:pm_4x4, from: :pm) do
  matrix [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
end

Fabricator(:pm_4x4_unnamed, from: :pm_4x4) do
  name nil
end

Fabricator(:pm_with_floats, from: :pm_unnamed) do
  matrix [[1.23, 4.56, 7.8, 9.0], [9, -8.7, 6.54, -3210]]
end

Fabricator(:pm_1, from: :pm) do
  matrix [[0,1,2,3],[4,5,6,7]]
  name 'motif_1'
end
Fabricator(:pm_2, from: :pm) do
  matrix [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
  name 'motif_2'
end
Fabricator(:pm_3, from: :pm) do
  matrix [[2,3,4,5],[6,7,8,9]]
  name 'motif_3'
end

Fabricator(:pm_4,from: :pm) do
  matrix [[1,0,1,0],[0,0,0,0],[1,2,3,4]]
  name 'pm 4'
end
Fabricator(:pm_5, from: :pm) do
  matrix [[1,2,1,2],[0,3,6,9],[1,2,3,4]]
  name 'pm 5'
end