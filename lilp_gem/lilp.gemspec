# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lilp/version"

Gem::Specification.new do |s|
  s.name        = "lilp"
  s.version     = Lilp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Sokol"]
  s.email       = ["mikaa123@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Lilp is lightweight literate programming}

  s.add_dependency 'redcarpet'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
