module CloudConvert
  class Error < StandardError
    # @return [Integer]
    attr_reader :code

    # @return [OpenStruct]
    attr_reader :errors

    # Raised when CloudConvert returns a 4xx HTTP status code
    ClientError = Class.new(self)

    # Raised when CloudConvert returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 401
    Unauthorized = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 402
    PaymentRequired = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 413
    RequestEntityTooLarge = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when CloudConvert returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when CloudConvert returns a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised when CloudConvert returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised when CloudConvert returns the HTTP status code 502
    BadGateway = Class.new(ServerError)

    # Raised when CloudConvert returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    # Raised when CloudConvert returns the HTTP status code 504
    GatewayTimeout = Class.new(ServerError)

    # Raised when CloudConvert returns a media related error
    MediaError = Class.new(self)

    # Raised when CloudConvert returns an InvalidMedia error
    InvalidMedia = Class.new(MediaError)

    # Raised when CloudConvert returns a media InternalError error
    MediaInternalError = Class.new(MediaError)

    # Raised when CloudConvert returns an UnsupportedMedia error
    UnsupportedMedia = Class.new(MediaError)

    # Raised when an operation subject to timeout takes too long
    TimeoutError = Class.new(self)

    ERRORS = {
      400 => CloudConvert::Error::BadRequest,
      401 => CloudConvert::Error::Unauthorized,
      402 => CloudConvert::Error::PaymentRequired,
      403 => CloudConvert::Error::Forbidden,
      404 => CloudConvert::Error::NotFound,
      406 => CloudConvert::Error::NotAcceptable,
      413 => CloudConvert::Error::RequestEntityTooLarge,
      422 => CloudConvert::Error::UnprocessableEntity,
      429 => CloudConvert::Error::TooManyRequests,
      500 => CloudConvert::Error::InternalServerError,
      502 => CloudConvert::Error::BadGateway,
      503 => CloudConvert::Error::ServiceUnavailable,
      504 => CloudConvert::Error::GatewayTimeout,
    }.freeze

    class << self
      # Create a new error from an HTTP response
      #
      # @param response [Faraday::Response]
      # @return [CloudConvert::Error]
      def from_response(response)
        klass = ERRORS[response.status] || self
        klass.new(response.body.message, response.body.code, response.body.errors)
      end
    end

    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [Integer]
    # @return [CloudConvert::Error]
    def initialize(message = "", code = nil, errors = {})
      super(message)

      @code = code
      @errors = errors
    end
  end
end
