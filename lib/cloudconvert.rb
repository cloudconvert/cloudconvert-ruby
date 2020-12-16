require "active_support/concern"
require "down"
require "equalizer"
require "faraday"
require "faraday_middleware"
require "forwardable"
require "json"
require "memoizable"
require "mimemagic"
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

module CloudConvert
  API_URL = "https://api.cloudconvert.com".freeze
  SANDBOX_URL = "https://api.sandbox.cloudconvert.com".freeze
  USER_AGENT = "CloudConvertRubyGem/#{CloudConvert::VERSION}".freeze
end
