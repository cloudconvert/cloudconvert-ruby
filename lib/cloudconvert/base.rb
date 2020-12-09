require "addressable/uri"
require "cloudconvert/null_object"
require "forwardable"
require "memoizable"
require "ostruct"

module CloudConvert
  class Base
    extend Forwardable
    include Memoizable
    # @return [Hash]
    attr_reader :attrs
    alias to_h attrs
    alias to_hash to_h

    class << self
      # Define methods that retrieve the value from attributes
      #
      # @param attrs [Array, Symbol]
      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      def predicate_attr_reader(*attrs)
        attrs.each do |attr|
          define_predicate_method(attr)
        end
      end

      # Define object methods from attributes
      #
      # @param klass [Symbol]
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def object_attr_reader(klass, key1, key2 = nil)
        define_attribute_method(key1, klass, key2)
        define_predicate_method(key1)
      end

      # Dynamically define a method for an attribute
      #
      # @param key1 [Symbol]
      # @param klass [Symbol]
      # @param key2 [Symbol]
      def define_attribute_method(key1, klass = nil, key2 = nil)
        define_method(key1) do
          if @attrs[key1].nil?
            NullObject.new
          elsif key1 === :operation || key1 === :status
            @attrs[key1].to_sym
          elsif @attrs[key1].is_a? Hash
            OpenStruct.new(@attrs[key1])
          elsif key1.end_with?("_at")
            Time.parse(@attrs[key1]).utc
          else
            klass.nil? ? @attrs[key1] : CloudConvert.const_get(klass).new(attrs_for_object(key1, key2))
          end
        end
        memoize(key1)
      end

      # Dynamically define a predicate method for an attribute
      #
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def define_predicate_method(key1, key2 = key1)
        predicate = key1.to_s.gsub(/_at$/, "")
        define_method(:"#{predicate}?") do
          !attr_falsey_or_empty?(key2)
        end
        memoize(:"#{predicate}?")
      end
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [CloudConvert::Base]
    def initialize(attrs = {})
      @attrs = attrs || {}
    end

    private

    def attr_falsey_or_empty?(key)
      !@attrs[key] || @attrs[key].respond_to?(:empty?) && @attrs[key].empty?
    end

    def attrs_for_object(key1, key2 = nil)
      if key2.nil?
        @attrs[key1]
      else
        attrs = @attrs.dup
        attrs.delete(key1).merge(key2 => attrs)
      end
    end
  end
end
