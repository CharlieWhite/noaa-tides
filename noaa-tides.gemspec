# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'noaa/tides/version'

Gem::Specification.new do |spec|
  spec.name          = "noaa-tides"
  spec.version       = Noaa::Tides::VERSION
  spec.authors       = ["Charlie White"]
  spec.email         = ["rcwhitejr@gmail.com"]
  spec.summary       = %q{Buoy & Tide data from the NOAA CO-OPS API}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"
  spec.add_dependency "activesupport"

end
