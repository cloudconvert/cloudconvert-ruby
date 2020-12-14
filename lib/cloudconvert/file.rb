module CloudConvert
  class File < Faraday::FilePart
    def initialize(file, content_type = nil, *parts)
      content_type ||= "text/plain" if file.is_a? StringIO
      content_type ||= MimeMagic.by_magic(file) || MimeMagic.by_path(file)
      super(file, content_type, *parts)
    end
  end
end
