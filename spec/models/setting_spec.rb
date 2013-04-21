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
      Setting.create(name: "my_name", value: "my value", description: "my description")
    end
 
    it "should be unique" do
      Setting.create(name: "my_name", value: "my value", description: "my description").should_not be_valid
      Setting.create(name: "another_name", value: "my value", description: "my description").should be_valid
    end

  end
  
  describe "class methods" do
    
    let(:setting) {create(:setting, name: "my_name", value: "my name", description: "my description")}
    
    it "should have valid class getter" do
      Setting.respond_to?(setting.name).should be_true
    end
    
    it "should have class setter" do
      Setting.respond_to?("#{setting.name}=").should be_true
    end
    
    it "getter method should return correct value" do
      Setting.my_name.should eql(setting.value)
    end
    
  end
  
end