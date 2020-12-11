module CloudConvert
  class Job < Entity
    # @return [String]
    attr_reader :id, :tag

    # @return [Symbol]
    symbol_attr_reader :status

    # @return [CloudConvert::Collection<CloudConvert::Task>]
    collection_attr_reader :Task, :tasks

    # @return [OpenStruct]
    struct_attr_reader :links

    # @return [Time]
    time_attr_reader :created_at, :started_at, :ended_at
  end
end
