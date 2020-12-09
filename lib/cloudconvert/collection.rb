require "ostruct"

module CloudConvert
  class Collection < Array
    attr_reader :links, :meta

    def initialize(items = [], links = {}, meta = {})
      super(items)
      @links = OpenStruct.new(links)
      @meta = OpenStruct.new(meta)
    end
  end
end
