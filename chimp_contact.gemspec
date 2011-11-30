# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chimp_contact/version"

Gem::Specification.new do |s|
  s.name        = "chimp_contact"
  s.version     = ChimpContact::VERSION
  s.authors     = ["Robert Williams"]
  s.email       = ["rob@r-williams.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "chimp_contact"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  # specify any dependencies here; for example:
  s.add_runtime_dependency "nokogiri"
end
