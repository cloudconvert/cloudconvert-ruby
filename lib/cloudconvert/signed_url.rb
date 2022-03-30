module CloudConvert
  class SignedUrl

    class << self

      # @param base [String] The base from for your signed URL settings.
      # @param signing_secret [String] The signing secret from for your signed URL settings.
      # @param job [Hash] The job to create the signed URL for
      # @param cache_key [String] Allows caching of the result file for 24h
      # @return [String] The signed URL
      def sign(base, signing_secret, job, cache_key = nil)

        url = base

        url += "?job=" + Base64.urlsafe_encode64(job.to_json, :padding => false)

        unless cache_key.nil?
          url += "&cache_key=" + cache_key
        end

        url += "&s=" + OpenSSL::HMAC.hexdigest("SHA256", signing_secret, url)

        return url

      end


    end
  end
end
