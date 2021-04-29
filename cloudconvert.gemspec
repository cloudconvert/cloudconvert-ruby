require_relative "lib/cloudconvert/version"

Gem::Specification.new do |spec|
  spec.name = "cloudconvert"
  spec.version = CloudConvert::VERSION
  spec.authors = ["Josias Montag", "Steve Lacey"]
  spec.email = %w[josias@montag.info steve@steve.ly]
  spec.description = "A Ruby interface to the CloudConvert API v2."
  spec.summary = spec.description
  spec.homepage = "https://cloudconvert.com/api/v2"
  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/cloudconvert/cloudconvert-ruby/issues",
    "documentation_uri" => "https://cloudconvert.com/api/v2",
    "source_code_uri"   => "https://github.com/cloudconvert/cloudconvert-ruby"
  }
  spec.files = %w[cloudconvert.gemspec LICENSE.txt README.md] + Dir["lib/**/*.rb"]
  spec.license = "MIT"
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 2.7"
  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_dependency "down", "~> 5.0"
  spec.add_dependency "equalizer"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "faraday_middleware", "~> 1.0"
  spec.add_dependency "forwardable"
  spec.add_dependency "json"
  spec.add_dependency "memoizable", "~> 0.4"
  spec.add_dependency "marcel", "~> 1.0.0"
  spec.add_dependency "openssl"
  spec.add_dependency "ostruct"
  spec.add_dependency "schemacop", "~> 2.4"
  spec.add_development_dependency "dotenv", "~> 2.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack", "~> 2.2"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.5"
  spec.add_development_dependency "securerandom"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr", "~> 6.0"
end
