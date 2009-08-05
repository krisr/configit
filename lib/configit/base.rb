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
      self.class.attributes
    end

    class << self
      # Returns a hash of Configit::Attribute's keyed by attribute name.
      def attributes
        @attributes ||= {}
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
        raise AttributeAlreadyDefined, name if attributes.has_key? name
        
        if options == {} && Hash === desc
          options = desc
          desc = nil
        end

        attr = Attribute.new(name, desc, options)
        attributes[name] = attr

        # Define the accessor
        attr_reader name

        define_method "#{name}=" do |value| 
          value = @@converters[attr.type].call(value)
          instance_variable_set("@#{name}", value)
          value
        end

        return attr
      end
    end
  end
end
