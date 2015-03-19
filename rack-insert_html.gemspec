# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/insert_html'

Gem::Specification.new do |spec|
  spec.name          = "rack-insert_html"
  spec.version       = Rack::InsertHtml::VERSION
  spec.authors       = ["Ian Yamey"]
  spec.email         = ["ian@policygenius.com"]

  spec.summary       = %q{Rack Middleware to insert a string into HTML responses}
  spec.description   = %q{Inserts strings into HTML responses. This is useful for adding <scripts>, <!-- Comments --> or <styles> to every page}
  spec.homepage      = "https://github.com/policygenius/rack-insert_html"
  
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rack-test", "~> 0.6.1"
end
