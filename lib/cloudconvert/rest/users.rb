module CloudConvert
  module REST
    module Users
      # @return [CloudConvert::User]
      def user
        CloudConvert::User.result(send_request(:get, "/v2/users/me"))
      end
    end
  end
end
