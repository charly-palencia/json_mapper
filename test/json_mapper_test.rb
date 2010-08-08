require "test_helper"
require "support/models"

class JSONMapperTest < Test::Unit::TestCase

  context "included in a model class" do

    setup do
      @klass = Class.new do
        include JSONMapper
        def to_s
          "TestUnitClass"
        end
      end
    end

    should "initialize empty attributes array" do
      @klass.attributes.should == []
    end

    should "allow adding a simple attribute mapping" do

      @klass.json_attribute :id, Integer

      @klass.attributes.size.should == 1
      @klass.attributes.first.name.should == :id
      @klass.attributes.first.source_attributes.should == [ :id ]
      @klass.attributes.first.type.should == Integer
      @klass.attributes.first.method_name.should == "id"

    end

    should "allow adding a complex attribute mapping" do
      @klass.json_attribute :id, [ :id, :attribute_id, :foo_id ], Integer
      @klass.attributes.size.should == 1
      @klass.attributes.first.name.should == :id
      @klass.attributes.first.source_attributes.should == [ :id, :attribute_id, :foo_id ]
      @klass.attributes.first.type.should == Integer
      @klass.attributes.first.method_name.should == "id"
    end

    should "parse simple json structure into a ruby object" do
      model = SimpleModel.parse(fixture_file("simple.json"))
      model.id.should == 1
      model.title.should == "Simple JSON title"
      model.boolean.should == true
    end

    should "assign value from different sources into an attribute" do

      model = ComplexModel.parse('{ "id": 1 }')
      model.id.should == 1

      model = ComplexModel.parse('{ "attribute_id": 1 }')
      model.id.should == 1

    end

    should "not overwrite initial value when assigning values from different sources into an attribute" do

      model = ComplexModel.parse('{ "id": 1, "attribute_id": 2 }')
      model.id.should == 1

    end
    
    should "assign another model into an attribute" do

      model = ComplexModel.parse('{ "simple": { "id": 1 } }')
      model.simple.id.should == 1

    end

    should "assign an array into an attribute" do

      model = ComplexModel.parse('{ "integers": [ 1, 2, 3 ] }')
      model.integers.should == [ 1, 2, 3 ]

    end

    should "assign an array of models into an attribute" do

      model = ComplexModel.parse('{ "simples": [{ "id": 1 }, { "id": 2 }] }')
      model.simples.size.should == 2
      model.simples.first.id.should == 1
      model.simples.last.id.should == 2

    end

    should "parse complex json structure into a ruby object" do
      model = ComplexModel.parse(fixture_file("complex.json"))
      model.id.should == 1
      model.model_title.should == "Complex JSON title"
      model.simple.id.should == 1
      model.simple.title.should == "Simple JSON title"
      model.simples.size.should == 2
      model.simples.first.id.should == 1
      model.simples.first.title.should == "Simple JSON title #1"
      model.simples.last.id.should == 2
      model.simples.last.title.should == "Simple JSON title #2"
    end

  end

end