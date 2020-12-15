module CloudConvert
  class Event < Entity
    include Equalizer.new(:event, :job)

    # @return [String]
    attr_reader :event

    # @return [String]
    alias_method :name, :event

    # @return [Boolean]
    object_attr_reader :Job, :job
  end
end
