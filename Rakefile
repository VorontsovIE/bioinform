#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Spec bioinform library'
task :spec do
  Dir.glob('spec/*_test.rb') do |spec_file|
    system("ruby #{spec_file}")
  end
  
  system('rspec -I ./spec spec/*_spec.rb')
end

# RSpec::Core::RakeTask.new