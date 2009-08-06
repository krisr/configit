require 'erb'
require 'yaml'

module Configit
  # The base class the custom configuration classes should derive from.
  # 
  # === Example
  #
  #   class FooConfig < Configit::Base
  #     attribute :name, "The name of the user", :required => true
  #     attribute :port, :required => true, :type => :integer, :default => 80
  #     attribute :log_level, :type => :symbol, :default => :debug
  #   end
  class Base
    @@converters ||= {
      :string  => lambda {|v| v.to_s},
      :integer => lambda {|v| v.to_i},
      :float   => lambda {|v| v.to_f},
      :symbol  => lambda {|v| v.to_sym}
    }

    # Returns the attributes defined for this class.
    def attributes
      @attributes ||= {}
    end

    def errors
      @errors ||= []
    end

    def clear_errors
      @errors = []
    end

    def ensure_valid!
      if !valid?
        message = "#{self.class.name} config invalid. #{self.errors.first}"
        raise ArgumentError, message
      end
      true
    end

    # Returns true if there are no errors, false otherwise
    def valid?
      clear_errors

      unknown_attributes = attributes.keys - schema.keys
      unknown_attributes.each do |key|
        errors << "#{key} is not a valid attribute name"
      end

      schema.values.each do |attribute|
        if error = attribute.validate(attributes[attribute.name])
          errors << error
        end
      end
      
      errors.empty?
    end

    def schema
      self.class.schema
    end

    class << self
      # Returns a hash of Configit::AttributeDefinition's keyed by attribute name.
      def schema
        @schema ||= {}
      end

      def evaluate_erb=(value)
        raise ArgumentError unless value == true || value == false
        @evaluate_erb = value
      end

      # Loads the config from a YAML string.
      # 
      # Unrecognized attributes are placed into the errors list.
      def load_from_string(string)
        config = self.new
        string = ERB.new(string).result unless @evaluate_erb == false
        (YAML.load(string) || {}).each do |key,value|
          key = key.to_sym
          config.attributes[key] = value
        end
        return config
      end

      # Load the config from a file.
      def load_from_file(filename)
        raise ArgumentError, "File #{filename} does not exist"  unless File.exists?(filename)
        raise ArgumentError, "File #{filename} is not readable" unless File.readable?(filename)

        return load_from_string(IO.read(filename))
      end

      # Same as load_from_string except it will raise an ArgumentError if the
      # config is not valid
      def load_from_string!(string)
        config = load_from_string(string)
        config.ensure_valid!
        config
      end

      # Same as load_from_file except it will raise an ArgumentError if the
      # config is not valid.
      def load_from_file!(filename)
        config = load_from_file(filename)
        config.ensure_valid!
        config
      end

      # Defines a new attribute on the config.
      # 
      # The first argument should be the name of the attribute.
      # 
      # If the next argument is a string it will be interpreted as the
      # description of the argument.
      #
      # The last argument should be a valid options hash.
      #
      # === Valid options
      #
      # [:required]
      #   Determines if the option is required or not. Should be either
      #   true or false
      # [:type]
      #   The type of the attribute. Should be one of :integer, :string
      #   :symbol, :float
      def attribute(name, desc=nil, options={})
        raise AttributeAlreadyDefined, name if schema.has_key? name
        
        if options == {} && Hash === desc
          options = desc
          desc = nil
        end

        attr = AttributeDefinition.new(name, desc, options)
        schema[name] = attr


        @attribute_module ||= begin
          m = Module.new 
          include m
          m
        end

        @attribute_module.class_eval do
          define_method name do
            value = attributes[name]
            if value != nil
              @@converters[attr.type].call(value)
            else
              value
            end
          end

          define_method "#{name}=" do |value| 
            attributes[name] = value
            value
          end
        end

        return attr
      end
    end
  end
end
