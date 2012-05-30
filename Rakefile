#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Spec bioinform library'
task :spec do
  Dir.glob('spec/*_spec.rb') do |spec_file|
    system("ruby #{spec_file}")
  end
end

# RSpec::Core::RakeTask.new