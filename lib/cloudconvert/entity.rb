require "cloudconvert/base"
require "cloudconvert/collection"
require "equalizer"

module CloudConvert
  class Entity < CloudConvert::Base
    include Equalizer.new(:id)

    class << self
      def collection(response)
        CloudConvert::Collection.new(
          response.data.collect { |item| new(item) },
          response.links,
          response.meta,
        )
      end

      def result(response)
        new response.data
      end
    end
  end
end
