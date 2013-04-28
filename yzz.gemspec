# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yzz/version'

Gem::Specification.new do |spec|
  spec.name          = "yzz"
  spec.version       = Yzz::VERSION
  spec.authors       = ["boris"]
  spec.email         = ["\"boris@iis.sinica.edu.tw\""]
  spec.description   = %q{A zz structure domain model.}
  spec.summary       = %q{Yzz module is a mixin that imbues object with zz qualities.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
