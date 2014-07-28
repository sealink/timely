# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timely/version'

Gem::Specification.new do |spec|
  spec.name          = "timely"
  spec.version       = Timely::VERSION
  spec.authors       = ["Michael Noack"]
  spec.email         = ["support@travellink.com.au"]
  spec.description   = %q{Set of time, date, weekday related methods.}
  spec.summary       = %q{Set of time, date, weekday related methods.}
  spec.homepage      = 'http://github.com/sealink/timely'

  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'actionpack'
end
