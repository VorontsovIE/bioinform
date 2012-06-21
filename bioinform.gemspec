# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bioinform/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ilya Vorontsov"]
  gem.email         = ["prijutme4ty@gmail.com"]
  gem.description   = %q{A bunch of useful classes for bioinformatics}
  gem.summary       = %q{Classes for work with different input formats of positional matrices and IUPAC-words and making simple transform and statistics with them. Also module includes several useful extensions for Enumerable module like parametric map and callable symbols }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bioinform"
  gem.require_paths = ["lib"]
  gem.version       = Bioinform::VERSION
  
  gem.add_dependency('active_support', '>= 3.0.0')
  
  gem.add_development_dependency "rspec", ">= 2.0"
end
