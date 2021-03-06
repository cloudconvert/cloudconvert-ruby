require "bundler/setup"
require "climate_control"
require "cloudconvert"
require "pry"
require "rack"
require "rspec"
require "securerandom"
require "stringio"
require "tempfile"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path(file)
  File.expand_path("fixtures/#{file}", __dir__)
end

def fixture(file)
  File.new(fixture_path(file))
end

def a_get(path)
  a_request(:get, url(path))
end

def a_post(path)
  a_request(:post, url(path))
end

def a_delete(path)
  a_request(:delete, url(path))
end

def stub_get(path)
  stub_request(:get, url(path))
end

def stub_post(path)
  stub_request(:post, url(path))
end

def stub_delete(path)
  stub_request(:delete, url(path))
end

def url(path)
  path.gsub(%r{^/}, CloudConvert::API_URL + "/")
end

def with_env(options, &block)
  ClimateControl.modify(options, &block)
end
