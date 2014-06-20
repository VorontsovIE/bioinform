$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rspec'
require 'rspec-given'

require 'fileutils'
require 'stringio'
# require 'fabrication'

require 'fakefs/spec_helpers'
require 'spec_helper_source'
# Fabrication.clear_definitions
