module CloudConvert
  class Collection < Array
    attr_reader :links, :meta

    def initialize(items = [], links = {}, meta = {})
      super(items)
      @links = links
      @meta = meta
    end
  end
end
