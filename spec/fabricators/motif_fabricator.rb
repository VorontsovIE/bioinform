Fabricator(:motif, from: Bioinform::Motif) do
end

Fabricator(:motif_with_name, from: :motif) do
  name 'Motif name'
end

Fabricator(:motif_pcm, from: :motif) do
#  pcm Fabricate(:pcm)
end

Fabricator(:motif_pwm, from: :motif) do
#  pwm Fabricate(:pwm)
end
=begin
Fabricator(:motif_ppm, from: :motif) do
  ppm Fabricate(:ppm)
end

Fabricator(:motif_pcm_and_ppm, from: :motif) do
  pcm Fabricate(:pcm)
  ppm Fabricate(:ppm)
end

Fabricator(:motif_pcm_and_pwm, from: :motif) do
  pcm Fabricate(:pcm)
  pwm Fabricate(:pwm_by_pcm)
end

Fabricator(:motif_pcm_and_inconsistent_pwm, from: :motif) do
  pcm Fabricate(:pcm)
  pwm Fabricate(:pwm_by_pwm_nonstandart_converter)
end
=end