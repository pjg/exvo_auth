# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exvo_auth/version"

Gem::Specification.new do |gem|
  gem.name        = "exvo_auth"
  gem.version     = ExvoAuth::VERSION
  gem.authors     = ["Jacek Becela", "Paweł Gościcki"]
  gem.email       = ["jacek.becela@gmail.com", "pawel.goscicki@gmail.com"]
  gem.homepage    = "https://github.com/Exvo/exvo_auth"
  gem.summary     = "User and App authentication for Exvo"
  gem.description = "Collection of users and applications authentication methods for use when you want your users or applications authorize using the Exvo platform."

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "httparty"
  gem.add_dependency "activemodel", "~> 3.0"
  gem.add_dependency "actionpack",  "~> 3.0"
  gem.add_dependency "exvo_helpers", "~> 0.2"

  gem.add_development_dependency "mocha"
  gem.add_development_dependency "test-unit"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-test"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "rb-inotify"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-rcov"
end
