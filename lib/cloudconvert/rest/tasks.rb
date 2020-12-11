module CloudConvert
  module REST
    module Tasks
      # @param id [String]
      # @param params [Hash]
      # @return [CloudConvert::Task]
      def task(id, params = {})
        CloudConvert::Task.result(send_request(:get, "/v2/tasks/#{id}", params))
      end

      # @param params [Hash]
      # @return [Array<CloudConvert::Task>]
      def tasks(params = {})
        CloudConvert::Task.collection(send_request(:get, "/v2/tasks", params))
      end

      # @param operation [String]
      # @param params [Hash]
      # @return [CloudConvert::Task]
      def create_task(params = {})
        schema = Schemacop::Schema.new do
          type :hash, allow_obsolete_keys: true do
            req :operation, :string
            req :input, :string unless params[:operation].nil? || params[:operation].start_with?("import")
          end
        end

        schema.validate! params

        CloudConvert::Task.result(send_request(:post, "/v2/#{params[:operation]}", params))
      end

      # @param params [Hash]
      # @return [CloudConvert::Task]
      def cancel_task(id)
        CloudConvert::Task.result(send_request(:post, "/v2/tasks/#{id}/cancel"))
      end

      # @param id [String]
      # @return [void]
      def delete_task(id)
        send_request(:delete, "/v2/tasks/#{id}")
      end

      # @param params [Hash]
      # @return [CloudConvert::Task]
      def retry_task(id)
        CloudConvert::Task.result(send_request(:post, "/v2/tasks/#{id}/retry"))
      end

      # @param id [String]
      # @return [CloudConvert::Task]
      def wait_for_task(id)
        CloudConvert::Task.result(send_request(:get, "/v2/tasks/#{id}/wait"))
      end

      # @param task [CloudConvert::Task]
      # @param file [File]
      # @return [Response]
      def upload(task, file)
        unless task.operation == "import/upload"
          raise ArgumentError.new("The task operation is not import/upload")
        end

        unless task.result && task.result.form && task.waiting?
          raise ArgumentError.new("The task is not ready for uploading")
        end

        send_request(:post, task.result.form.url, task.result.form.parameters.dup.merge(file: file))
      end
    end
  end
end
