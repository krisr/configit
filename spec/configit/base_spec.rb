require File.join(File.dirname(__FILE__), %w[.. spec_helper])

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

    it "should add the attribute to the attributes of the class" do
      FooConfig.attributes[:foo].should == @foo
    end

    it "should define the attribute successfully" do
      @foo.should_not be_nil
      @foo.should be_a Configit::Attribute
    end

    it "should set the name of the attribute" do
      @foo.name.should == :foo
    end

    it "should set the desc of the attribute" do
      @foo.desc.should == "Foo description"
    end

    it "should set the required state of the attribute" do
      @foo.required.should == true
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
      FooConfig.attribute :string, :type => :string
      FooConfig.attribute :symbol, :type => :symbol
      FooConfig.attribute :float, :type => :float

      config = FooConfig.new

      config.integer = "3"
      config.integer.should == 3
      config.integer = 3
      config.integer.should == 3
      config.integer = 3.3
      config.integer.should == 3
      config.integer = "foo"
      config.integer.should == 0
    end

    it "should set type to :string by default" do
      @bar.type.should == :string
    end

    it "should set required to false by default" do
      @bar.required.should == false
    end

    it "should raise an AttributeAlreadyDefined exception when an attribute is
        defined twice" do
      lambda {
        FooConfig.attribute :foo
      }.should raise_error(Configit::AttributeAlreadyDefined)
    end
  end

  it "should load from a string" do
    pending
  end

  it "should load from a file" do
    pending
  end

  it "should validate required attributes correctly" do
    pending
  end

  it "should convert types to the correct ruby data type" do
    pending
  end

    # config.valid.should be_true
    # config.errors.should be_empty
    # config.print_error_messages.should be_nil
    # config.print_documentation
end

# EOF
