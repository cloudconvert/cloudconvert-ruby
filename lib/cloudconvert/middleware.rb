module CloudConvert
  module Middleware
    class ParseJson < FaradayMiddleware::ParseJson
      define_parser do |body, parser_options|
        JSON.parse(body, object_class: OpenStruct) unless body.blank?
      end
    end

    ParseXml = Class.new(FaradayMiddleware::ParseXml)
  end
end
