require "cloudconvert/entity"

module CloudConvert
  class User < CloudConvert::Entity
    # @return [Integer]
    attr_reader :id, :credits

    # @return [String]
    attr_reader :username, :email

    # @return [Boolean]
    attr_reader :paying

    # @return [Time]
    attr_reader :created_at

    # @return [OpenStruct]
    attr_reader :links
  end
end
