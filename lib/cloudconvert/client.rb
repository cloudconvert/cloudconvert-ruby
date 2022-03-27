module CloudConvert
  class Client
    attr_reader :api_key, :sandbox

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [CloudConvert::Client]
    def initialize(options = {})
      schema = Schemacop::Schema.new do
        req! :api_key, :string
        opt! :sandbox, :boolean, default: false
      end

      schema.validate! options.reverse_merge!({
        api_key: ENV["CLOUDCONVERT_API_KEY"],
        sandbox: ENV["CLOUDCONVERT_SANDBOX"].to_s.downcase == "true",
      })

      @api_key = options[:api_key]
      @sandbox = options[:sandbox]
    end

    # @return [Resources::Jobs]
    def jobs
      @jobs ||= Resources::Jobs.new(self)
    end

    # @return [Resources::Tasks]
    def tasks
      @tasks ||= Resources::Tasks.new(self)
    end

    # @return [Resources::Users]
    def users
      @users ||= Resources::Users.new(self)
    end

    # @param method [Symbol]
    # @param path [String]
    # @param params [Hash]
    # @return [OpenStruct]
    def request(method, path, params = {}, &block)
      response = connection.send(method, path, params, &block)
      raise CloudConvert::Error.from_response(response) unless response.success?
      response.body unless response.body.blank?
    end

    # @param path [String]
    # @param params [Hash]
    # @return [OpenStruct]
    def get(path, params = {}, &block)
      request(:get, path, params, &block)
    end

    # @param path [String]
    # @param params [Hash]
    # @return [OpenStruct]
    def post(path, params = {}, &block)
      request(:post, path, params, &block)
    end

    # @param path [String]
    # @param params [Hash]
    # @return [OpenStruct]
    def delete(path, params = {}, &block)
      request(:delete, path, params, &block)
    end

    # @param url [String]
    # @return [Tempfile]
    def download(url, *args, **options)
      options[:headers] ||= {}
      options[:headers]["User-Agent"] = USER_AGENT
      Down.download(url, *args, **options)
    end

    # @return [String]
    def api_host
      @api_host ||= sandbox ? SANDBOX_URL : API_URL
    end

    # @return [String]
    def api_sync_host
      @api_sync_host ||= sandbox ? SANDBOX_SYNC_URL : API_SYNC_URL
    end

    private

    # @return [Faraday::Client]
    def connection
      @connection ||= Faraday.new(url: api_host, headers: headers) do |f|
        f.adapter Faraday.default_adapter
        f.request :json
        f.request :multipart
        f.use CloudConvert::Middleware::ParseJson, content_type: /\bjson$/
        f.use FaradayMiddleware::FollowRedirects, callback: lambda { |response, redirect|
          redirect.request_headers.delete("Content-Length")
          redirect.request_headers.delete("Content-Type")
        }
      end
    end

    # @return [Hash]
    def headers
      @headers ||= {
        "Authorization": "Bearer #{api_key}",
        "User-Agent": USER_AGENT,
      }
    end
  end
end
