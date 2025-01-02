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
  s.date = "2025-01-02"
  s.files = [".gitignore".freeze, ".ruby-version".freeze, ".yardopts".freeze, "CHANGELOG.md".freeze, "Gemfile".freeze, "Gemfile.lock".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "VERSION".freeze, "albus.gemspec".freeze, "config/locales/de.yml".freeze, "config/locales/en.yml".freeze, "config/locales/fr.yml".freeze, "db/migrate/create_albus_asteps.rb".freeze, "lib/albus.rb".freeze, "lib/albus/astep_mixin.rb".freeze, "lib/albus/controller_mixin.rb".freeze, "lib/albus/engine.rb".freeze, "lib/albus/final_step_config.rb".freeze, "lib/albus/form_component_factory.rb".freeze, "lib/albus/next_step_config.rb".freeze, "lib/albus/step_data_factory.rb".freeze, "lib/albus/step_definition.rb".freeze, "lib/albus/step_definition_mixins/setup_common.rb".freeze, "lib/albus/step_definition_mixins/setup_edit.rb".freeze, "lib/albus/step_definition_mixins/setup_new.rb".freeze, "lib/albus/version.rb".freeze, "lib/albus/view_helpers.rb".freeze, "lib/generators/albus/install/install_generator.rb".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.3.5".freeze)
  s.rubygems_version = "3.6.1".freeze
  s.summary = "This gem lets Rails programmers create complex wizards instantly using a simple DSL, while handling transitions and state automatically.".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<yard>.freeze, [">= 0.9.28".freeze])
  s.add_runtime_dependency(%q<rails>.freeze, [">= 7.2.1".freeze])
  s.add_runtime_dependency(%q<compony>.freeze, [">= 0.5.3".freeze])
  s.add_runtime_dependency(%q<anchormodel>.freeze, [">= 0.2.4".freeze])
end