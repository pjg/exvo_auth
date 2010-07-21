# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{exvo-auth}
  s.version = "0.7.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacek Becela"]
  s.date = %q{2010-07-21}
  s.description = %q{Sign in with Exvo account}
  s.email = %q{jacek.becela@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "exvo-auth.gemspec",
     "lib/exvo-auth.rb",
     "lib/exvo_auth/autonomous/auth.rb",
     "lib/exvo_auth/autonomous/base.rb",
     "lib/exvo_auth/autonomous/cache.rb",
     "lib/exvo_auth/autonomous/consumer.rb",
     "lib/exvo_auth/autonomous/http.rb",
     "lib/exvo_auth/autonomous/provider.rb",
     "lib/exvo_auth/config.rb",
     "lib/exvo_auth/controllers/base.rb",
     "lib/exvo_auth/controllers/merb.rb",
     "lib/exvo_auth/controllers/rails.rb",
     "lib/exvo_auth/oauth2.rb",
     "lib/exvo_auth/strategies/base.rb",
     "lib/exvo_auth/strategies/interactive.rb",
     "lib/exvo_auth/strategies/non_interactive.rb",
     "test/helper.rb",
     "test/test_exvo_auth.rb",
     "test/test_integration.rb"
  ]
  s.homepage = %q{http://github.com/Exvo/Auth}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Sign in with Exvo account}
  s.test_files = [
    "test/helper.rb",
     "test/test_exvo_auth.rb",
     "test/test_integration.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oa-oauth>, ["= 0.0.1"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.6.1"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<test-unit>, [">= 2.1.0"])
    else
      s.add_dependency(%q<oa-oauth>, ["= 0.0.1"])
      s.add_dependency(%q<httparty>, [">= 0.6.1"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<test-unit>, [">= 2.1.0"])
    end
  else
    s.add_dependency(%q<oa-oauth>, ["= 0.0.1"])
    s.add_dependency(%q<httparty>, [">= 0.6.1"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<test-unit>, [">= 2.1.0"])
  end
end

