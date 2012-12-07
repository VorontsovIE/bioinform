Fabricator(:motif, class_name: Bioinform::Motif) do
end

Fabricator(:motif_with_name, from: :motif) do
  name 'Motif name'
end

Fabricator(:motif_pcm, from: :motif) do
  pcm(fabricator: :pcm)
end

Fabricator(:motif_pwm, from: :motif) do
  pwm(fabricator: :pwm)
end

Fabricator(:motif_ppm, from: :motif) do
  ppm(fabricator: :ppm)
end

Fabricator(:motif_pcm_and_ppm, from: :motif) do
  pcm(fabricator: :pcm)
  ppm(fabricator: :ppm)
end

Fabricator(:motif_pwm_and_ppm, from: :motif) do
  pwm(fabricator: :pwm)
  ppm(fabricator: :ppm)
end

Fabricator(:motif_pcm_and_pwm, from: :motif) do
  pcm(fabricator: :pcm)
  pwm(fabricator: :pwm)
end