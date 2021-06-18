# -*- encoding: utf-8 -*-
require File.expand_path("#{File.dirname(__FILE__)}/lib/knife_cookbook_doc/version")

Gem::Specification.new do |s|
  s.authors       = ['Mathias Lafeldt', 'Peter Donald']
  s.email         = %w(mathias.lafeldt@gmail.com peter@realityforge.org)
  s.description   = %q{Knife plugin to generate README.md for a cookbook}
  s.summary       = s.description
  s.homepage      = 'http://realityforge.github.com/knife-cookbook-doc'
  s.license       = 'Apache 2.0'

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = 'knife-cookbook-doc'
  s.require_paths = %w(lib)
  s.version       = KnifeCookbookDoc::VERSION

  s.add_dependency 'chef', '>= 12.3'
  s.add_dependency 'erubis'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
