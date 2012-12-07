Fabricator(:three_elements_collection, class_name: Bioinform::Collection, aliases: [:pm_collection]) do
  name 'PM_collection'
  after_build{|collection| collection << Fabricate(:pm_1) << Fabricate(:pm_2) << Fabricate(:pm_3) }
end

Fabricator(:unnamed_pm_collection, from: :pm_collection) do
  name nil
end