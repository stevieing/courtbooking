require 'spec_helper'

describe Setting do
  
  subject {create(:setting)}
  
  context "with valid attributes" do
    
    it {should be_valid}

    its(:name)          {should_not be_blank}
    its(:value)         {should_not be_blank}
    its(:description)   {should_not be_blank}
  end
  
  describe "with invalid attributes" do
    
    let(:setting) {create(:setting)}
    
    it "no name" do
      setting.update_attributes(name: nil).should be_false
    end
    
    it "no value" do
      setting.update_attributes(value: nil).should be_false
    end
    
    it "no description" do
      setting.update_attributes(description: nil).should be_false
    end
    
    it "invalid name" do
      setting.update_attributes(name: "my name").should be_false
      setting.update_attributes(name: "$my_name").should be_false
      setting.update_attributes(name: "#my_name").should be_false
    end
    
  end
  
  describe "name" do

    before(:each) do
      create(:setting, name: "my_name", value: "my value", description: "my description")
    end
 
    it "should be unique" do
      build(:setting, name: "my_name", value: "my value", description: "my description").should_not be_valid
      build(:setting, name: "another_name", value: "my value", description: "my description").should be_valid
    end

  end
  
  describe "constants" do
    
    before(:each) do
      @setting = create(:setting, name: "my_name", value: "my value", description: "my description")
    end
    
    it "should exist" do
      Rails.configuration.my_name.should == @setting.value
    end
    
    it "should be modified when value changes" do
      @setting.update_attributes(value: "new value")
      Rails.configuration.my_name.should == "new value"
    end
    
    describe "should have the correct format" do
      
      it "numeric" do
        @setting.update_attributes(value: "21")
        Rails.configuration.my_name.should be_instance_of(Fixnum)
      end
      
      it "time" do
        @setting.update_attributes(value: "23:59")
        Rails.configuration.my_name.should be_instance_of(Time)
      end
    end
      
  end
  
end