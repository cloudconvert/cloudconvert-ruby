require "cloudconvert/entity"

module CloudConvert
  class Task < CloudConvert::Entity
    # @return [String]
    attr_reader :id, :operation, :job_id, :status, :message, :code

    # @return [Array<CloudConvert::Task>]
    attr_reader :depends_on_tasks

    # @return [OpenStruct]
    attr_reader :payload, :result, :links

    # @return [Time]
    attr_reader :created_at, :started_at, :ended_at
  end
end
