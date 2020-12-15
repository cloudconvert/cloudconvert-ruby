module CloudConvert
  class Webhook
    # Raised when a webhook is malformed
    Error = Class.new(CloudConvert::Error)

    # Raised when a webhook does not match the CloudConvert-Signature
    InvalidSignature = Class.new(Error)

    # Raised when a webhook does not have a CloudConvert-Signature
    MissingSignature = Class.new(Error)

    class << self
      # @param payload [String] The full request body (the JSON string) of our request to the webhook URL.
      # @return [Event]
      def event(payload)
        Event.new(JSON.parse(payload, object_class: OpenStruct))
      end

      # @param payload [String] The full request body (the JSON string) of our request to the webhook URL.
      # @param signature [String] The value from the CloudConvert-Signature.
      # @param secret [String] The signing secret from for your webhook settings.
      # @return [Boolean]
      def valid?(payload, signature, secret)
        OpenSSL::HMAC.hexdigest("SHA256", secret, payload) == signature
      end

      # @param payload [String] The full request body (the JSON string) of our request to the webhook URL.
      # @param signature [String] The value from the CloudConvert-Signature.
      # @param secret [String] The signing secret from for your webhook settings.
      # @return [Event]
      def verify(payload, signature, secret, &block)
        raise MissingSignature.new("Missing webhook signature") if signature.nil? || signature.empty?
        raise InvalidSignature.new("Invalid webhook signature") unless valid?(payload, signature, secret)
        yield event payload if block_given?
        true
      end

      # @param request [Rack::Request] The request to the webhook URL from CloudConvert.
      # @param secret [String] The signing secret from for your webhook settings.
      # @return [Event]
      def verify_request(request, secret, &block)
        verify(request.body, request.get_header(SIGNATURE), secret, &block)
      end
    end
  end
end
