require "equalizer"
require "faraday"
require "faraday_middleware"
require "forwardable"
require "json"
require "memoizable"
require "ostruct"
require "schemacop"

require "cloudconvert/base"
require "cloudconvert/client"
require "cloudconvert/collection"
require "cloudconvert/entity"
require "cloudconvert/error"
require "cloudconvert/job"
require "cloudconvert/middleware"
require "cloudconvert/task"
require "cloudconvert/user"
require "cloudconvert/version"

module CloudConvert
  API_URL = "https://api.cloudconvert.com".freeze
  SANDBOX_URL = "https://api.sandbox.cloudconvert.com".freeze
  USER_AGENT = "CloudConvertRubyGem/#{CloudConvert::VERSION}".freeze
end
