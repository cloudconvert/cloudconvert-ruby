require "cloudconvert/rest/jobs"
require "cloudconvert/rest/tasks"
require "cloudconvert/rest/users"

module CloudConvert
  module REST
    module API
      include CloudConvert::REST::Jobs
      include CloudConvert::REST::Tasks
      include CloudConvert::REST::Users
    end
  end
end
