module CloudConvert
  class Task < Entity
    # @return [String]
    attr_reader :id, :name, :operation, :message, :code,
                :engine, :engine_version, :host_name, :storage,
                :job_id, :copy_of_task_id, :retry_of_task_id

    # @return [Symbol]
    symbol_attr_reader :status

    # @return [Integer]
    attr_reader :percent, :priority

    # @return [CloudConvert::Collection<CloudConvert::Task>]
    collection_attr_reader :Task, :depends_on_tasks, :retries

    # @return [OpenStruct]
    struct_attr_reader :payload, :result, :links

    # @return [Time]
    time_attr_reader :created_at, :started_at, :ended_at

    # @return [Boolean]
    def error?
      status == :error
    end

    # @return [Boolean]
    def finished?
      status == :finished
    end

    # @return [Boolean]
    def processing?
      status == :processing
    end

    # @return [Boolean]
    def waiting?
      status == :waiting
    end
  end
end
