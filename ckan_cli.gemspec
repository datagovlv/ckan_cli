
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ckancli/version"

Gem::Specification.new do |spec|
  spec.name          = "ckan_cli"
  spec.license       = "MIT"
  spec.version       = Ckancli::VERSION
  spec.authors       = ["datagovlv"]
  spec.email         = ["dati@varam.gov.lv"]
  spec.summary       = "CKAN command line interface."
  spec.description   = "CKAN CLI with built-in CSV file validation and CKAN API integration."
  spec.homepage      = "https://github.com/datagovlv/ckan_cli"

  spec.files         = Dir['lib/**/*']
  spec.files        += Dir['bin/*']
  spec.files        += Dir['exe/*']
  spec.files        += Dir['ckan_cli.gemspec', 'README.md', 'LICENSE.txt', 'Rakefile']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "tty-color", "~> 0.4"
  spec.add_dependency "tty-logger", "~> 0.6.0"
  spec.add_dependency "tty-platform", "~> 0.2.0"
  spec.add_dependency "tty-progressbar", "~> 0.16.0"
  spec.add_dependency "tty-spinner", "~> 0.9.0"
  spec.add_dependency "tty-which", "~> 0.4"
  spec.add_dependency "thor", "~> 0.20.0"
  spec.add_dependency "csvlint", "~> 1.3"
  spec.add_dependency "rest-client", "~> 2.0.2"
  spec.add_dependency "mail", "~> 2.7.1"
  spec.add_dependency "colorize", "~> 1.1.0"
  spec.add_dependency "pastel", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
