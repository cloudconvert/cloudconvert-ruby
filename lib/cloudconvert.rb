require "active_support/concern"
require "active_support/core_ext/hash/reverse_merge"
require "down"
require "equalizer"
require "faraday"
require "faraday_middleware"
require "forwardable"
require "json"
require "memoizable"
require "marcel"
require "openssl"
require "ostruct"
require "schemacop"

require "cloudconvert/base"
require "cloudconvert/client"
require "cloudconvert/collection"
require "cloudconvert/entity"
require "cloudconvert/error"
require "cloudconvert/event"
require "cloudconvert/file"
require "cloudconvert/job"
require "cloudconvert/middleware"
require "cloudconvert/resource"
require "cloudconvert/resources/jobs"
require "cloudconvert/resources/tasks"
require "cloudconvert/resources/users"
require "cloudconvert/task"
require "cloudconvert/user"
require "cloudconvert/version"
require "cloudconvert/webhook"
require "cloudconvert/webhook/processor"
require "cloudconvert/signed_url"

module CloudConvert
  API_URL = "https://api.cloudconvert.com".freeze
  SANDBOX_URL = "https://api.sandbox.cloudconvert.com".freeze
  API_SYNC_URL = "https://sync.api.cloudconvert.com".freeze
  SANDBOX_SYNC_URL = "https://sync.api.sandbox.cloudconvert.com".freeze
  USER_AGENT = "CloudConvertRubyGem/#{CloudConvert::VERSION}".freeze
end
