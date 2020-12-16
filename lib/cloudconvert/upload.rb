module CloudConvert
  class Upload < Base
    # @return [String]
    attr_reader :bucket, :etag, :key, :location
  end
end
