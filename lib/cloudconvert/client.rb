require "cloudconvert/rest/api"

module CloudConvert
  class Client
    include CloudConvert::REST::API

    attr_accessor :api_key, :base_url, :proxy, :sandbox, :timeouts, :user_agent

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

      yield(self) if block_given?

      schema = Schemacop::Schema.new do
        req! :api_key, :string
        opt! :sandbox, :boolean, default: false
      end

      schema.validate!({ api_key: @api_key, sandbox: @sandbox }.compact)

      @client = Faraday.new({
        url: base_url,
        headers: {
          "Authorization" => "Bearer #{api_key}",
          "User-Agent" => user_agent,
        },
      })
    end

    # @return [String]
    def base_url
      if sandbox
        @base_url ||= CloudConvert::SANDBOX_URL
      else
        @base_url ||= CloudConvert::API_URL
      end
    end

    # @param method [Symbol]
    # @param path [String]
    # @param params [Hash]
    # @return [Faraday::Response]
    def send_request(method, path, params = {})
      params[:file] = Faraday::FilePart.new(params[:file]) unless params[:file].nil?
      response = @client.public_send(method, path, params)
      JSON.parse(response.body, object_class: OpenStruct) unless response.body.blank?
    end

    # @return [String]
    def user_agent
      @user_agent ||= "CloudConvertRubyGem/#{CloudConvert::VERSION}"
    end
  end
end
