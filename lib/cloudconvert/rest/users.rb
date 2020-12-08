require "cloudconvert/rest/utils"
require "cloudconvert/user"

module CloudConvert
  module REST
    module Users
      include CloudConvert::REST::Utils

      # @return [CloudConvert::User]
      def user
        perform_get_with_object("/users/me", {}, CloudConvert::User)
      end
    end
  end
end
