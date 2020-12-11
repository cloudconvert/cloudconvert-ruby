module CloudConvert
  module Resources
    class Users < Resource
      # @return [User]
      def me
        User.result(client.get("/v2/users/me"))
      end
    end
  end
end
