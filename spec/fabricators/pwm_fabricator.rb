Fabricator(:pwm, from: Bioinform::PWM) do
  initialize_with{ Bioinform::PWM.new(matrix: [[1,2,3,4],[5,6,7,8]], name: 'PWM_name')}
end
Fabricator(:pwm_by_pcm, from: Bioinform::PWM) do
  initialize_with{ Fabricate(:pcm).to_pwm }
  name 'PWM_name'
end

Fabricator(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_1, from: :pwm) do
  matrix [[-0.47, 0.118, 0.486, -0.47],[0.754, -2.079, -0.47, 0.118]]
end

Fabricator(:rounded_upto_3_digits_pwm_by_pcm_with_pseudocount_10, from: :pwm) do
  matrix [[-0.194, 0.057, 0.258, -0.194],[0.425, -0.531, -0.194, 0.057]]
end
