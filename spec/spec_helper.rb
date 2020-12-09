require "bundler/setup"
require "cloudconvert"
require "rspec"
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

def a_delete(path)
  a_request(:delete, CloudConvert::API_V2 + path)
end

def a_get(path)
  a_request(:get, CloudConvert::API_V2 + path)
end

def a_post(path)
  a_request(:post, CloudConvert::API_V2 + path)
end

def a_put(path)
  a_request(:put, CloudConvert::API_V2 + path)
end

def stub_delete(path)
  stub_request(:delete, CloudConvert::API_V2 + path)
end

def stub_get(path)
  stub_request(:get, CloudConvert::API_V2 + path)
end

def stub_post(path)
  stub_request(:post, CloudConvert::API_V2 + path)
end

def stub_put(path)
  stub_request(:put, CloudConvert::API_V2 + path)
end

def fixture_path
  File.expand_path("fixtures", __dir__)
end

def fixture(file)
  File.new(fixture_path + "/" + file)
end
