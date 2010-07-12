require 'test_helper'

class ActiveMongoMetaTest < Test::Unit::TestCase

  context "A new model with active_mongo_meta" do
    setup do
      @foo = Foo.new :metadata => {:has_foo => "yes of course", :has_bar => "never"}
    end
    
    should "have metadata" do
      assert @foo.metadata.is_a? ActiveMongoMeta
      assert @foo.metadata.has_foo == "yes of course"
      assert @foo.has_foo == "yes of course"
      assert @foo.metadata.has_bar == "never"
      assert @foo.has_bar == "never"
    end
    
    should "allow setting new datum" do
      @foo.metadata.define_datum(:has_poo, "yup")
      assert @foo.metadata.has_poo == "yup" 
    end
  end
  
  context "An existing model with active_mongo_meta" do
    setup do
      x = Foo.create :metadata => {:has_foo => "yes of course", :has_bar => "never"}
      @foo = Foo.find x.id
    end
    
    should "have meta_data" do
      assert @foo.metadata.is_a? ActiveMongoMeta
      assert @foo.metadata.has_foo == "yes of course"
      assert @foo.has_foo == "yes of course"
      assert @foo.metadata.has_bar == "never"
      assert @foo.has_bar == "never"
    end
    
    should "allow setting new datum" do
      @foo.metadata.define_datum(:has_poo, "yup")
      assert @foo.metadata.has_poo == "yup" 
    end
  end
end
