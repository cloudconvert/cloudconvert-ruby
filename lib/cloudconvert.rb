require "equalizer"
require "faraday"
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
require "cloudconvert/task"
require "cloudconvert/user"
require "cloudconvert/version"

module CloudConvert
  API_URL = "https://api.cloudconvert.com"
  SANDBOX_URL = "https://api.sandbox.cloudconvert.com"
end
