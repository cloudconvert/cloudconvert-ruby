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

      # Define collection methods from attributes
      #
      # @param klass [Symbol]
      # @param attrs [Array, Symbol]
      def collection_attr_reader(klass, *attrs)
        attrs.each do |attr|
          define_collection_method(attr, klass)
          define_predicate_method(attr)
        end
      end

      # Define object methods from attributes
      #
      # @param klass [Symbol]
      # @param attrs [Array, Symbol]
      def object_attr_reader(klass, *attrs)
        attrs.each do |attr|
          define_object_method(attr)
          define_predicate_method(attr)
        end
      end

      # Define predicate methods from attributes
      #
      # @param attrs [Array, Symbol]
      def predicate_attr_reader(*attrs)
        attrs.each do |attr|
          define_predicate_method(attr)
        end
      end

      # Define struct methods from attributes
      #
      # @param attrs [Array, Symbol]
      def struct_attr_reader(*attrs)
        attrs.each do |attr|
          define_struct_method(attr)
          define_predicate_method(attr)
        end
      end

      # Define symbol methods from attributes
      #
      # @param attrs [Array, Symbol]
      def symbol_attr_reader(*attrs)
        attrs.each do |attr|
          define_symbol_method(attr)
        end
      end

      # Define time methods from attributes
      #
      # @param attrs [Array, Symbol]
      def time_attr_reader(*attrs)
        attrs.each do |attr|
          define_time_method(attr)
          define_predicate_method(attr.to_s.gsub(/_at$/, ""), attr)
        end
      end

      private

      # Dynamically define a method for an attribute
      #
      # @param key [Symbol]
      # @param klass [Symbol]
      def define_attribute_method(key)
        define_method(key) do
          @attrs[key]
        end
        memoize(key)
      end

      # Dynamically define a collection method for an attribute
      #
      # @param key [Symbol]
      # @param klass [Symbol]
      def define_collection_method(key, klass)
        define_method(key) do
          collection = @attrs[key] || []
          entity = CloudConvert.const_get(klass)
          collection.map { |item| entity.new(item) }
        end
        memoize(key)
      end

      # Dynamically define a predicate method for an attribute
      #
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def define_predicate_method(key1, key2 = key1)
        define_method(:"#{key1}?") do
          !attr_falsey_or_empty?(key2)
        end
        memoize(:"#{key1}?")
      end

      # Dynamically define a object method for an attribute
      #
      # @param key [Symbol]
      def define_object_method(key, klass)
        define_method(key) do
          CloudConvert.const_get(klass).new(@attrs[key])
        end
        memoize(key)
      end

      # Dynamically define a struct method for an attribute
      #
      # @param key [Symbol]
      def define_struct_method(key)
        define_method(key) do
          OpenStruct.new(@attrs[key]) unless @attrs[key].nil?
        end
        memoize(key)
      end

      # Dynamically define a symbol method for an attribute
      #
      # @param key [Symbol]
      def define_symbol_method(key)
        define_method(key) do
          @attrs[key].to_sym unless @attrs[key].nil?
        end
        memoize(key)
      end

      # Dynamically define a time method for an attribute
      #
      # @param key [Symbol]
      def define_time_method(key)
        define_method(key) do
          Time.parse(@attrs[key]).utc unless @attrs[key].nil?
        end
        memoize(key)
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
  end
end
