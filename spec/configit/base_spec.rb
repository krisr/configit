require File.join(File.dirname(__FILE__), %w[.. spec_helper])

require 'tempfile'

describe Configit::Base do
  before :each do
    Object.send(:remove_const, :FooConfig) if Object.const_defined? :FooConfig
    class FooConfig < Configit::Base; end
  end

  describe "class.attribute" do
    before do
      @foo = FooConfig.attribute :foo, "Foo description",
                                  :required => true, 
                                  :type => :integer
      @bar = FooConfig.attribute :bar
    end

    it "should add the attribute to the schema of the class" do
      FooConfig.schema[:foo].should == @foo
    end

    it "should define the attribute successfully" do
      @foo.should_not be_nil
      @foo.should be_a Configit::AttributeDefinition
    end

    it "should set the name of the attribute" do
      @foo.name.should == :foo
    end

    it "should set the desc of the attribute" do
      @foo.desc.should == "Foo description"
    end

    it "should set the required state of the attribute" do
      @foo.required?.should == true
    end
    
    it "should set the type of the attribute" do
      @foo.type.should == :integer
    end

    it "should add an attribute accessor to the class for the attribute" do
      config = FooConfig.new
      config.respond_to?(:foo).should be_true
      config.respond_to?(:foo=).should be_true
    end

    it "should properly convert the type of attribute on read and set" do
      FooConfig.attribute :integer, :type => :integer
      FooConfig.attribute :string,  :type => :string
      FooConfig.attribute :symbol,  :type => :symbol
      FooConfig.attribute :float,   :type => :float

      config = FooConfig.new

      config.integer = "3"
      config.attributes[:integer].should == "3"
      config.integer.should == 3
      config.integer = 3
      config.integer.should == 3
      config.integer = 3.3
      config.integer.should == 3
      config.integer = "foo"
      config.integer.should == 0

      # Need to test rest of conversions
      pending
    end

    it "should set type to :string by default" do
      @bar.type.should == :string
    end

    it "should set required to false by default" do
      @bar.required?.should == false
    end

    it "should raise an AttributeAlreadyDefined exception when an attribute is
        defined twice" do
      lambda {
        FooConfig.attribute :foo
      }.should raise_error(Configit::AttributeAlreadyDefined)
    end
  end
  
  it "should enforce that required attributes are present" do
    FooConfig.attribute :foo, :required => true
    config = FooConfig.load_from_string("")
    config.valid?.should be_false
  end
  
  it "should be valid when required attributes with default values are absent" do
    FooConfig.attribute :foo, :required => true, :default => "foo"
    config = FooConfig.load_from_string("")
    config.valid?.should be_true
  end

  it "should be valid when non required attributes are abset" do
    FooConfig.attribute :foo, :required => false
    config = FooConfig.load_from_string("")
    config.valid?.should be_true
  end

  describe ".load_from_string!" do
    it "should raise an ArgumentError if the config is not valid" do
      lambda {
        FooConfig.load_from_string! "asdfasdf: adf"
      }.should raise_error(ArgumentError, /asdfasdf/)
    end
  end
  
  describe ".load_from_file!" do
    it "should raise an ArgumentError if the config is not valid" do
      file = Tempfile.new("config")
      file.write "foo1: bar"
      file.flush
      file.close
      lambda {
        config = FooConfig.load_from_file!(file.path)
      }.should raise_error(ArgumentError, /foo1/)
    end
  end

  describe ".load_from_string" do
    before do
      FooConfig.attribute :foo, :type => :integer
      FooConfig.attribute :bar, :type => :string
    end

    it "should load a valid yaml config from a string successfully" do
      config = FooConfig.load_from_string %q{
                  foo: 3
                  bar: bar value
                  }

      config.foo.should == 3
      config.bar.should == "bar value"
      config.valid?.should be_true
    end

    it "should create errors when it sees unknown schema" do
      config = FooConfig.load_from_string %q{
                  something: 3
                  bar: bar value
                  }

      config.valid?.should == false
      config.errors.first.should =~ /something/
    end

    it "should evaluate erb successfully" do
      config = FooConfig.load_from_string %q{
                  bar: <%= "foo " + "bar" %>
                  }
      config.bar.should == "foo bar"
    end

    it "should not evaluate erb if .evaluate_erb is set to false" do
      FooConfig.evaluate_erb = false
      config = FooConfig.load_from_string %q{
                  bar: <%= 3 %>
                  }
      config.bar.should == "<%= 3 %>"
    end
  end

  describe ".load_from_file" do
    before do
      FooConfig.attribute :foo
      FooConfig.attribute :bar
    end

    it "should load from a file successfully" do
      file = Tempfile.new("config")
      file.write "foo: bar"
      file.flush
      file.close
      config = FooConfig.load_from_file(file.path)
      config.foo.should == 'bar'
    end
    
    it "should raise an ArgumentError when the file does not exist" do
      lambda {
        FooConfig.load_from_file("/etc/kajdf33sdf")
      }.should raise_error(ArgumentError)
    end

    it "should raise an ArgumentError if the file is not readable" do
      file = Tempfile.new("config")
      file.write "foo: bar"
      file.flush
      file.close
      File.chmod(0000, file.path)
      lambda {
        config = FooConfig.load_from_file(file.path)
      }.should raise_error(ArgumentError)
    end
  end

  describe ".clear_errors" do
    it "should clear the errors on the config" do
      config = FooConfig.new
      config.attributes['foo'] = 3
      config.valid?.should == false
      config.clear_errors
      config.errors.should == []
    end
  end

  it "should enable you to override attribute methods and use super" do
    FooConfig.attribute :foo, :type => :symbol
    FooConfig.attribute :bar, :type => :symbol
    FooConfig.class_eval do
      def foo
        super || bar
      end
    end
    config = FooConfig.new
    config.bar = :bar
    config.foo.should == :bar
    config.foo = :foo
    config.foo.should == :foo
  end
end

# EOF
