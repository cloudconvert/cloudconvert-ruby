module CloudConvert::Webhook::Processor
  extend ActiveSupport::Concern

  # Raised when the webhook_secret has not been supplied
  UnspecifiedSecret = Class.new(CloudConvert::Webhook::Error)

  included do
    before_action :authenticate_cloudconvert_request!, only: :create
    skip_before_action :verify_authenticity_token, only: :create
  end

  def create
    method = event.name.gsub(".", "_")
    raise NoMethodError.new("#{name}##{method} not implemented") unless self.respond_to?(method, true)
    self.send(method, event)
    head(:ok)
  end

  private

  def authenticate_cloudconvert_request!
    raise UnspecifiedSecret.new unless respond_to?(:webhook_secret, true)

    begin
      CloudConvert::Webhook.verify(payload, signature, webhook_secret(event))
    rescue CloudConvert::Webhook::Error
      head(:bad_request)
    end
  end

  def event
    @event ||= CloudConvert::Webhook.event(payload)
  end

  def payload
    @payload ||= (
      request.body.rewind
      request.body.read
    )
  end

  def signature
    @signature ||= request.headers[CloudConvert::SIGNATURE]
  end
end
