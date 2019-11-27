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

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'actionpack'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'travis'
end
