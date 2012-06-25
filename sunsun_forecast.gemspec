# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sunsun/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wataru MIYAGUNI"]
  gem.email         = ["gonngo@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sunsun"
  gem.require_paths = ["lib"]
  gem.version       = Sunsun::VERSION

  gem.add_runtime_dependency 'sinatra'
  gem.add_runtime_dependency 'sequel'
  gem.add_runtime_dependency 'sqlite3'
  gem.add_runtime_dependency 'unicorn'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'fabrication'
  gem.add_development_dependency 'active_support'
  gem.add_development_dependency 'shotgun'
end
