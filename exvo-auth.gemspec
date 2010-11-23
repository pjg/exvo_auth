# -*- encoding: utf-8 -*-
require File.expand_path("../lib/exvo_auth/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "exvo-auth"
  s.version     = ExvoAuth::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jacek Becela"]
  s.email       = ["jacek.becela@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/exvo-auth"
  s.summary     = "Sign in with Exvo account"
  s.description = "Sign in with Exvo account"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "exvo-auth"
  
  s.add_dependency "oa-oauth",    "~> 0.0.4"
  s.add_dependency "httparty",    "~> 0.6.1"
  s.add_dependency "activemodel", "> 3.0.0"

  s.add_development_dependency "mocha",     "~> 0.9.8"
  s.add_development_dependency "test-unit", "~> 2.1.0"
  s.add_development_dependency "bundler",   "~> 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
