require "cloudconvert/rest/utils"
require "cloudconvert/task"
require "schemacop"

module CloudConvert
  module REST
    module Tasks
      include CloudConvert::REST::Utils

      # @param id [String]
      # @param options [Hash]
      # @return [CloudConvert::Task]
      def task(id, options = {})
        perform_get_with_object("/tasks/#{id}", options, CloudConvert::Task)
      end

      # @param options [Hash]
      # @return [Array<CloudConvert::Task>]
      def tasks(options = {})
        perform_get_with_objects("/tasks", options, CloudConvert::Task)
      end

      # @param operation [String]
      # @param options [Hash]
      # @return [CloudConvert::Task]
      def create_task(options = {})
        schema = Schemacop::Schema.new do
          type :hash, allow_obsolete_keys: true do
            req :operation, :string
            req :input, :string unless options[:operation].nil? || options[:operation].start_with?("import")
          end
        end

        schema.validate! options

        perform_post_with_object("/#{options[:operation]}", options, CloudConvert::Task)
      end

      # @param options [Hash]
      # @return [CloudConvert::Task]
      def cancel_task(id)
        perform_post_with_object("/tasks/#{id}/cancel", {}, CloudConvert::Task)
      end

      # @param id [String]
      # @return [void]
      def delete_task(id)
        perform_delete("/tasks/#{id}")
      end

      # @param options [Hash]
      # @return [CloudConvert::Task]
      def retry_task(id)
        perform_post_with_object("/tasks/#{id}/retry", {}, CloudConvert::Task)
      end

      # @param id [String]
      # @return [CloudConvert::Task]
      def wait_for_task(id)
        perform_get_with_object("/tasks/#{id}/wait", {}, CloudConvert::Task)
      end

      # @param options [Hash]
      # @param file [String, Resource, Stream]
      # @return [Response]
      def upload(task, file)
        if task.operation != "import/upload"
          # raise BadMethodCallException("The task operation is not import/upload")
        end

        if task.status != Task::STATUS_WATING || !task.result || !task.result.form
          # raise BadMethodCallException("The task is not ready for uploading")
        end

        client.upload(task.result.form.url, file, task.result.form.parameters || {})
      end
    end
  end
end
