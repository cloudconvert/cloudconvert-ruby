require "cloudconvert/job"
require "schemacop"

module CloudConvert
  module REST
    module Jobs
      # @param id [String]
      # @param params [Hash]
      # @return [CloudConvert::Job]
      def job(id, params = {})
        CloudConvert::Job.result(send_request(:get, "/v2/jobs/#{id}", params))
      end

      # @param params [Hash]
      # @return [Array<CloudConvert::Job>]
      def jobs(params = {})
        CloudConvert::Job.collection(send_request(:get, "/v2/jobs", params))
      end

      # @param params [Hash]
      # @return [CloudConvert::Job]
      def create_job(params)
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

        CloudConvert::Job.result(send_request(:post, "/v2/jobs", payload))
      end

      # @param id [String]
      # @return [CloudConvert::Job]
      def wait_for_job(id)
        CloudConvert::Job.result(send_request(:get, "/v2/jobs/#{id}/wait", {}))
      end

      # @param id [String]
      # @return [void]
      def delete_job(id)
        send_request(:delete, "/v2/jobs/#{id}")
      end
    end
  end
end
