Fabricator(:collection_with_3_pcms, from: Collection) do
  after_build{|collection| collection << Fabricate(:pcm_1) << Fabricate(:pcm_2) << Fabricate(:pcm_3)}
end

Fabricator(:collection_with_3_pcms_and_1_pwm, from: Collection) do
  after_build{|collection| collection << Fabricate(:pcm_1) << Fabricate(:pcm_2) << Fabricate(:pcm_3) << Fabricate(:pwm)}
end