require "cloudconvert/rest/jobs"
require "cloudconvert/rest/tasks"
require "cloudconvert/rest/users"
require "cloudconvert/rest/utils"

module CloudConvert
  module REST
    module API
      include CloudConvert::REST::Jobs
      include CloudConvert::REST::Tasks
      include CloudConvert::REST::Users
      include CloudConvert::REST::Utils
    end
  end
end
