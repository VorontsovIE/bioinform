require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  $LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
  $LOAD_PATH.unshift File.dirname(__FILE__)

  require 'rspec'
  require 'rspec-given'

  require 'fileutils'
  require 'stringio'
  require 'fabrication'

  require 'fakefs/spec_helpers'  
end

Spork.each_run do
  require 'spec_helper_source'
  Fabrication.clear_definitions
end