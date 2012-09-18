Fabricator(:pwm, from: Bioinform::PWM) do
  initialize_with{ Fabricate(:pcm, name: 'PWM_name').to_pwm }
end