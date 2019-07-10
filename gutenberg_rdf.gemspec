lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gutenberg_rdf/version"

Gem::Specification.new do |spec|
  spec.name          = "gutenberg_rdf"
  spec.version       = GutenbergRdf::VERSION
  spec.authors       = ["Michael R. Cook"]
  spec.email         = ["git@mrcook.uk"]

  spec.summary       = %q{Read Project Gutenberg RDF catalog files.}
  spec.description   = %q{A Ruby wrapper for the Project Gutenberg RDF catalog files.}
  spec.homepage      = "https://github.com/mrcook/gutenberg_rdf"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0" # UTF-8 is required

  # spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.5", ">= 3.5.0"
end
