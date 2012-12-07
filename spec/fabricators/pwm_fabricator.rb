Fabricator(:pwm, class_name: Bioinform::PWM) do
  initialize_with{ Bioinform::PWM.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PWM_name')}
end

# It has name 'PCM_name' because name isn't converted during #to_pwm
Fabricator(:pwm_by_pcm, class_name: Bioinform::PWM) do
  initialize_with{ Fabricate(:pcm).to_pwm }
end

Fabricator(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_1, from: :pwm) do
  matrix [[-0.47, 0.118, 0.486, -0.47],[0.754, -2.079, -0.47, 0.118]]
end

Fabricator(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_10, from: :pwm) do
  matrix [[-0.194, 0.057, 0.258, -0.194],[0.425, -0.531, -0.194, 0.057]]
end
