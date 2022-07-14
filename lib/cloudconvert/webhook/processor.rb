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
    raise NoMethodError.new("#{self.class.name}##{method} not implemented") unless respond_to?(method, true)
    send(method, event)
    head(:ok)
  end

  private

  def authenticate_cloudconvert_request!
    raise UnspecifiedSecret.new unless respond_to?(:webhook_secret, true)
    head(:bad_request) unless CloudConvert::Webhook.verify_request(request, webhook_secret(event))
  end

  def event
    @event ||= CloudConvert::Webhook.event(request.body.read)
  end
end
