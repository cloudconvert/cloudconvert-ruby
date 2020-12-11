module CloudConvert
  module Resources
    class Jobs < Resource
      # @param params [Hash]
      # @return [Collection<Job>]
      def all(params = {})
        Job.collection(client.get("/v2/jobs", params))
      end

      # @param id [String]
      # @param params [Hash]
      # @return [Job]
      def find(id, params = {})
        Job.result(client.get("/v2/jobs/#{id}", params))
      end

      # @param params [Hash]
      # @return [Job]
      def create(params)
        schema = Schemacop::Schema.new do
          type :hash, allow_obsolete_keys: true do
            req :tasks, :array, min: 1 do
              type :hash, allow_obsolete_keys: true do
                req :operation, :string
              end
            end
          end
        end

        schema.validate! params

        payload = params.dup

        payload[:tasks] = payload[:tasks].to_h do |task|
          [task[:name], task.reject { |k| k === :name }]
        end

        Job.result(client.post("/v2/jobs", payload))
      end

      # @param id [String]
      # @return [Job]
      def wait(id)
        Job.result(client.get("/v2/jobs/#{id}/wait", {}))
      end

      # @param id [String]
      # @return [void]
      def delete(id)
        client.delete("/v2/jobs/#{id}")
      end
    end
  end
end
