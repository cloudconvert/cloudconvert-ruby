require_relative "lib/cloudconvert/version"

Gem::Specification.new do |spec|
  spec.name = "cloudconvert"
  spec.version = CloudConvert::VERSION
  spec.authors = ["Josias Montag", "Steve Lacey"]
  spec.email = %w[josias@montag.info steve@steve.ly]
  spec.description = "A Ruby interface to the CloudConvert API v2."
  spec.summary = spec.description
  spec.homepage = "https://cloudconvert.com/api/v2"
  spec.files = %w[cloudconvert.gemspec LICENSE.txt README.md] + Dir["lib/**/*.rb"]
  spec.license = "MIT"
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 2.7"
  spec.add_dependency "equalizer"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "faraday_middleware", "~> 1.0"
  spec.add_dependency "forwardable"
  spec.add_dependency "json"
  spec.add_dependency "memoizable", "~> 0.4.0"
  spec.add_dependency "ostruct"
  spec.add_dependency "schemacop", "~> 2.4"
end
