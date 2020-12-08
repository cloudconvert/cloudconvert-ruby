require "cloudconvert/entity"

module CloudConvert
  class Job < CloudConvert::Entity
    # @return [String]
    attr_reader :id, :status, :tag

    # @return [Array<CloudConvert::Task>]
    attr_reader :tasks

    # @return [OpenStruct]
    attr_reader :links

    # @return [Time]
    attr_reader :created_at, :started_at, :ended_at
  end
end
