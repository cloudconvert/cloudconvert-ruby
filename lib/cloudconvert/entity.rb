module CloudConvert
  class Entity < Base
    attr_reader :id

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
