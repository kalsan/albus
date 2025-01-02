require 'bundler/gem_tasks'
require_relative 'lib/albus/version'

File.open('VERSION', 'w') { |f| f.puts(Albus::Version::LABEL) }

task :gemspec do
  specification = Gem::Specification.new do |s|
    s.name = 'albus'
    s.version = Albus::Version::LABEL
    s.author = ['Sandro Kalbermatter', 'contributors']
    s.summary = 'This gem lets Rails programmers create complex wizards instantly using a simple DSL, while handling transitions and state automatically.'
    s.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
    s.executables   = []
    s.require_paths = ['lib']
    s.required_ruby_version = '>= 3.3.5'

    # Dependencies
    s.add_development_dependency 'yard', '>= 0.9.28'

    s.add_runtime_dependency 'rails', '>= 7.2.1'
    s.add_runtime_dependency 'compony', '>= 0.5.3'
    s.add_runtime_dependency 'anchormodel', '>= 0.2.4'
  end

  File.open('albus.gemspec', 'w') do |f|
    f.puts('# DO NOT EDIT')
    f.puts("# This file is auto-generated via: 'rake gemspec'.\n\n")
    f.write(specification.to_ruby.strip)
  end
end
