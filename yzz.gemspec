# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yzz/version'

Gem::Specification.new do |spec|
  spec.name          = "yzz"
  spec.version       = Yzz::VERSION
  spec.authors       = ["boris"]
  spec.email         = ["\"boris@iis.sinica.edu.tw\""]
  spec.summary       = %q{A domain model of Ted Nelson's ZZ structures.}
  spec.description   = %q{Mixin Yzz imbues the includer with qualities of a ZZ structure cell.}
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
