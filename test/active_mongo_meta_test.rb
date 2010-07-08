require 'test_helper'

class ActiveMongoMetaTest < Test::Unit::TestCase
  context "A new ActiveMongoMeta document" do
    setup do
      @amm = ActiveMongoMeta.new :has_cheez => true, "blah" => false
    end
    
    should "allow defining datum without a value" do
      @amm.define_datum(:has_poo)
      assert @amm.has_poo == nil
    end
    
    should "allow defining datum with a value" do
      @amm.define_datum(:has_poo, "yes I do")
      assert @amm.has_poo == "yes I do"
    end
    
    should "have datum defined" do
      assert @amm.metadata["has_cheez"] == true
      assert @amm.metadata["blah"] == false
      assert @amm.has_cheez == true
      assert @amm.blah == false
    end
    
    should "have keys defined" do
      assert (@amm.metadata.keys - ["has_cheez", "blah"]).empty?
    end
    
    context "with a datum defined" do
      setup do
        @amm.define_datum(:has_poo)
      end
      
      should "allow setting and getting the datum" do
        assert @amm.has_poo != "no I don't"
        @amm.has_poo = "no I don't"
        assert @amm.has_poo == "no I don't"
      end
      
      should "have keys defined" do
        assert (@amm.metadata.keys - ["has_cheez", "blah", "has_poo"]).empty?
      end
    end
  end

  
end

