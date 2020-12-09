require "cloudconvert/error"
require "cloudconvert/rest/api"
require "cloudconvert/version"

module CloudConvert
  class Client
    include CloudConvert::REST::API
    include CloudConvert::Version

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
    end

    # @return [String]
    def base_url
      if sandbox
        @base_url ||= CloudConvert::SANDBOX_V2
      else
        @base_url ||= CloudConvert::API_V2
      end
    end

    # @return [String]
    def user_agent
      @user_agent ||= "CloudConvertRubyGem/#{CloudConvert::Version}"
    end
  end
end
