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
      def verify(payload, signature, secret)
        OpenSSL::HMAC.hexdigest("SHA256", secret.to_s, payload.to_s) == signature
      end

      # @param payload [String] The full request body (the JSON string) of our request to the webhook URL.
      # @param signature [String] The value from the CloudConvert-Signature.
      # @param secret [String] The signing secret from for your webhook settings.
      # @raise [MissingSignature, InvalidSignature]
      # @return [Boolean]
      def verify!(payload, signature, secret)
        raise MissingSignature.new("Missing webhook signature") if signature.to_s.empty?
        raise InvalidSignature.new("Invalid webhook signature") unless verify(payload, signature, secret)
        true
      end

      # @param request [Request] The request to the webhook URL from CloudConvert.
      # @param secret [String] The signing secret from for your webhook settings.
      # @return [Boolean]
      def verify_request(request, secret)
        verify request.body.rewind && request.body.read, request.get_header("HTTP_CLOUDCONVERT_SIGNATURE"), secret
      end

      # @param request [Request] The request to the webhook URL from CloudConvert.
      # @param secret [String] The signing secret from for your webhook settings.
      # @raise [MissingSignature, InvalidSignature]
      # @return [Boolean]
      def verify_request!(request, secret)
        verify! request.body.rewind && request.body.read, request.get_header("HTTP_CLOUDCONVERT_SIGNATURE"), secret
      end
    end
  end
end
