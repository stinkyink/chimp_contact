# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chimp_contact/version"

Gem::Specification.new do |s|
  s.name        = "chimp_contact"
  s.version     = ChimpContact::VERSION
  s.authors     = ["Robert Williams", "Andrew Warburton"]
  s.email       = ["rob@r-williams.com", "andy@warburton.me"]
  s.homepage    = ""
  s.summary     = %q{Converts mailchimp templates to constant contact format}
  s.description = %q{Converts mailchimp templates to constant contact format but more verbose}

  s.rubyforge_project = "chimp_contact"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"
  # specify any dependencies here; for example:
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "hominid"
end
