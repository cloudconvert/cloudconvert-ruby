module CloudConvert
  class File < Faraday::Multipart::FilePart
    def initialize(file, content_type = nil, *parts)
      content_type ||= "text/plain" if file.is_a? StringIO
      content_type ||= Marcel::Magic.by_magic(file) || Marcel::Magic.by_path(file)
      super(file, content_type, *parts)
    end
  end
end
