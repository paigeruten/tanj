lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tanj/version"

Gem::Specification.new do |spec|
  spec.name          = "tanj"
  spec.version       = Tanj::VERSION
  spec.authors       = ["Pailey Quilts"]
  spec.email         = ["paileyq@gmail.com"]

  spec.summary       = %q{tools for print statement debugging}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'binding_of_caller', '~> 0.8'
  spec.add_runtime_dependency 'paint', '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
