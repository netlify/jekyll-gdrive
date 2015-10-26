# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/gdrive/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-gdrive"
  spec.version       = Jekyll::Gdrive::VERSION
  spec.authors       = ["Mathias Biilmann Christensen"]
  spec.email         = ["mathias@netlify.com"]
  spec.summary       = %q{Google Sheets access from your Jekyll sites}
  spec.description   = %q{Access Data from a Google Sheet through the GDrive API in your Jekyll sites}
  spec.homepage      = "https://github.com/netlify/jekyll-gdrive"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "google_drive", "~> 1.0"
  spec.add_runtime_dependency "highline"
end
