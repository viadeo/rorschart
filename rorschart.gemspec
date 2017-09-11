# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rorschart/version'

Gem::Specification.new do |spec|
  spec.name          = "rorschart"
  spec.version       = Rorschart::VERSION
  spec.authors       = ["Eric Pantera"]
  spec.email         = ["eric.pantera@gmail.com"]
  spec.description   = %q{Interprets Rails data structures for you to generate beautiful Google Charts}
  spec.summary       = %q{Beautiful Google Charts from Rails data structures}
  spec.homepage      = "https://github.com/viadeo/rorschart"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_runtime_dependency 'activerecord4-redshift-adapter', '~> 0.2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord", '~> 4.2.0'
  spec.add_development_dependency "sqlite3"  
end
