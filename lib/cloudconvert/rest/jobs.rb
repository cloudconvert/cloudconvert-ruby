require "cloudconvert/rest/utils"
require "cloudconvert/job"
require "schemacop"

module CloudConvert
  module REST
    module Jobs
      include CloudConvert::REST::Utils

      # @param id [String]
      # @param options [Hash]
      # @return [CloudConvert::Job]
      def job(id, options = {})
        perform_get_with_object("/jobs/#{id}", options, CloudConvert::Job)
      end

      # @param options [Hash]
      # @return [Array<CloudConvert::Job>]
      def jobs(options = {})
        perform_get_with_objects("/jobs", options, CloudConvert::Job)
      end

      # @param options [Hash]
      # @return [CloudConvert::Job]
      def create_job(options)
        schema = Schemacop::Schema.new do
          type :hash, allow_obsolete_keys: true do
            req :tasks, :array, min: 1 do
              type :hash, allow_obsolete_keys: true do
                req :operation, :string
              end
            end
          end
        end

        schema.validate! options

        perform_post_with_object("/jobs", options, CloudConvert::Job)
      end

      # @param id [String]
      # @return [CloudConvert::Job]
      def wait_for_job(id)
        perform_get_with_object("/jobs/#{id}/wait", options, CloudConvert::Job)
      end

      # @param id [String]
      # @return [void]
      def delete_job(id)
        perform_delete("/jobs/#{id}")
      end
    end
  end
end
