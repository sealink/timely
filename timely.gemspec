# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timely/version'

Gem::Specification.new do |spec|
  spec.name          = 'timely'
  spec.version       = Timely::VERSION
  spec.authors       = ['Michael Noack']
  spec.email         = ['support@travellink.com.au']
  spec.description   = 'Set of time, date, weekday related methods.'
  spec.summary       = 'Set of time, date, weekday related methods.'
  spec.homepage      = 'http://github.com/sealink/timely'

  spec.license       = 'MIT'

  spec.files = Dir["CHANGELOG.md", "README.md", "timely.gemspec", "lib/**/*"]
  spec.executables   = []
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_development_dependency 'activerecord', '>=6', '<8'
  spec.add_development_dependency 'activesupport', '>=6', '<8'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'pry'
end
