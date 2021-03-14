
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "query_delegator/version"

Gem::Specification.new do |spec|
  spec.name          = "query_delegator"
  spec.version       = QueryDelegator::VERSION
  spec.authors       = ["Ritchie Paul Buitre"]
  spec.email         = ["ritchie@richorelse.com"]

  spec.summary       = "Write composable and table agnostic query objects for Active Record scopes."
  spec.description   = "Move query code from ActiveRecord models into query objects, because database query code do not belong in the model."
  spec.homepage      = "https://github.com/RichOrElse/query_delegator"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.2"
  spec.add_runtime_dependency "activesupport", ">= 5.1.7"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest", "~> 5.1"
end
