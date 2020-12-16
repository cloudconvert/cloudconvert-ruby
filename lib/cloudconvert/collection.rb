module CloudConvert
  class Collection < Array
    attr_reader :links, :meta

    def initialize(items = [], links = {}, meta = {})
      super(items)
      @links = links
      @meta = meta
    end

    def where(attrs)
      self.class.new select { |item| attrs.map { |k, v| item.send(k) == v ? true : nil }.compact.length == attrs.length }
    end
  end
end
