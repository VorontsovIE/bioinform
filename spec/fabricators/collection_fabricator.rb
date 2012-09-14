Fabricator(:pm_collection, from: Bioinform::Collection, aliases: [:two_elements_collection]) do
  name 'PM_collection'
  after_build{|collection| collection << Fabricate(:pm_first) << Fabricate(:pm_second) }
end

Fabricator(:unnamed_pm_collection, from: :pm_collection) do
  name nil
end