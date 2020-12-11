require "cloudconvert/rest/api"

module CloudConvert
  class Client
    include CloudConvert::REST::API

    attr_accessor :api_key, :sandbox

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [CloudConvert::Client]
    def initialize(options = {})
      @api_key = ENV["CLOUDCONVERT_API_KEY"]
      @sandbox = ENV["CLOUDCONVERT_SANDBOX"].to_s.downcase === "true"

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      schema = Schemacop::Schema.new do
        req! :api_key, :string
        opt! :sandbox, :boolean, default: false
      end

      schema.validate!({ api_key: @api_key, sandbox: @sandbox }.compact)
    end

    # @return [String]
    def api_host
      @api_host ||= sandbox ? CloudConvert::SANDBOX_URL : CloudConvert::API_URL
    end

    # @return [Faraday::Client]
    def connection
      @connection ||= Faraday.new(url: api_host, headers: headers) do |builder|
        builder.adapter Faraday.default_adapter
        builder.request :url_encoded
        builder.use CloudConvert::Middleware::ParseJson, content_type: /\bjson$/
      end
    end

    # @return [Hash]
    def headers
      @headers ||= {
        "Authorization": "Bearer #{api_key}",
        "User-Agent" => CloudConvert::USER_AGENT,
      }
    end

    # @param method [Symbol]
    # @param path [String]
    # @param params [Hash]
    # @return [Faraday::Response]
    def send_request(method, path, params = {})
      params[:file] = Faraday::FilePart.new(params[:file]) unless params[:file].nil?

      response = connection.send(method, path, params)

      raise CloudConvert::Error.from_response(response) unless response.success?

      response.body unless response.body.blank?
    end
  end
end
