# DO NOT EDIT
# This file is auto-generated via: 'rake gemspec'.

# -*- encoding: utf-8 -*-
# stub: albus 0.0.1.edge ruby lib

Gem::Specification.new do |s|
  s.name = "albus".freeze
  s.version = "0.0.1.edge".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sandro Kalbermatter".freeze, "contributors".freeze]
  s.date = "2024-12-23"
  s.required_ruby_version = Gem::Requirement.new(">= 3.3.5".freeze)
  s.rubygems_version = "3.6.1".freeze
  s.summary = "This gem lets Rails programmers create complex wizards instantly using a simple DSL, while handling transitions and state automatically.".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<yard>.freeze, [">= 0.9.28".freeze])
  s.add_runtime_dependency(%q<rails>.freeze, [">= 7.2.1".freeze])
  s.add_runtime_dependency(%q<compony>.freeze, [">= 0.5.3".freeze])
end