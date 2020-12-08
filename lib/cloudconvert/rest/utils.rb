require "cloudconvert/rest/request"

module CloudConvert
  module REST
    module Utils
      private

      # @param path [String]
      # @param options [Hash]
      def perform_get(path, options = {})
        perform_request(:get, path, options)
      end

      # @param path [String]
      # @param options [Hash]
      def perform_post(path, options = {})
        perform_request(:post, path, options)
      end

      # @param path [String]
      # @param options [Hash]
      def perform_delete(path, options = {})
        perform_request(:delete, path, options)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      def perform_request(request_method, path, options = {}, params = nil)
        CloudConvert::REST::Request.new(self, request_method, path, options, params).perform
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_get_with_object(path, options, klass)
        perform_request_with_object(:get, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_object(path, options, klass)
        perform_request_with_object(:post, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_object(request_method, path, options, klass, params = nil)
        response = perform_request(request_method, path, options, params)
        klass.new(response[:data])
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_get_with_objects(path, options, klass)
        perform_request_with_objects(:get, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_objects(path, options, klass)
        perform_request_with_objects(:post, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_objects(request_method, path, options, klass)
        perform_request(request_method, path, options)[:data].collect do |element|
          klass.new(element)
        end
      end
    end
  end
end
