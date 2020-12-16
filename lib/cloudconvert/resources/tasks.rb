module CloudConvert
  module Resources
    class Tasks < Resource
      # @param params [Hash]
      # @return [Collection<Task>]
      def all(params = {})
        Task.collection(client.get("/v2/tasks", params))
      end

      # @param id [String]
      # @param params [Hash]
      # @return [Task]
      def find(id, params = {})
        Task.result(client.get("/v2/tasks/#{id}", params))
      end

      # @param operation [String]
      # @param params [Hash]
      # @return [Task]
      def create(params = {})
        schema = Schemacop::Schema.new do
          type :hash, allow_obsolete_keys: true do
            req :operation, :string
            req :input, :string unless params[:operation].nil? || params[:operation].start_with?("import")
          end
        end

        schema.validate! params

        Task.result(client.post("/v2/#{params[:operation]}", params))
      end

      # @param params [Hash]
      # @return [Task]
      def cancel(id)
        Task.result(client.post("/v2/tasks/#{id}/cancel"))
      end

      # @param id [String]
      # @return [void]
      def delete(id)
        client.delete("/v2/tasks/#{id}")
      end

      # @param params [Hash]
      # @return [Task]
      def retry(id)
        Task.result(client.post("/v2/tasks/#{id}/retry"))
      end

      # @param id [String]
      # @return [Task]
      def wait(id)
        Task.result(client.get("/v2/tasks/#{id}/wait"))
      end

      # @param file [File, String, IO] Either a String filename to a local file or an open IO object.
      # @param task [Task] The "import/upload" Task to upload the file to.
      # @return [void]
      def upload(file, task)
        unless task.operation == "import/upload"
          raise ArgumentError.new("The task operation is not import/upload")
        end

        unless task.result && task.result.form && task.waiting?
          raise ArgumentError.new("The task is not ready for uploading")
        end

        file = File.new(file) unless file.is_a? File

        client.post(task.result.form.url, task.result.form.parameters.to_h.merge(file: file)) do |request|
          request.headers.delete("Authorization")
          request.headers["Content-Type"] = "multipart/form-data"
        end

        nil
      end
    end
  end
end
