lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gutenberg_rdf/version'

Gem::Specification.new do |spec|
  spec.name          = "gutenberg_rdf"
  spec.version       = GutenbergRdf::VERSION
  spec.authors       = ["Michael R. Cook"]
  spec.email         = ["git@mrcook.uk"]
  spec.summary       = %q{A Ruby wrapper for the Project Gutenberg RDF catalog files.}
  spec.description   = %q{GutenbergRdf provides a useful API to the metadata found in any Project Gutenberg book RDF}
  spec.summary       = %q{API for any Project Gutenberg book RDF}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0" # depending on UTF-8 by default

  spec.add_dependency "nokogiri", "~> 1.6.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec", "~> 2.14.1"
end