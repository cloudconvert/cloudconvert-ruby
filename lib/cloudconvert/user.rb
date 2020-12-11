module CloudConvert
  class User < CloudConvert::Entity
    # @return [Integer]
    attr_reader :id, :credits

    # @return [String]
    attr_reader :username, :email

    # @return [Boolean]
    predicate_attr_reader :paying

    # @return [OpenStruct]
    struct_attr_reader :links

    # @return [Time]
    time_attr_reader :created_at
  end
end
