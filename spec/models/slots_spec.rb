require 'spec_helper'

describe Slots do

  let!(:slots) { Slots.new("06:40", "22:00", 40)}
  
  it "should have the correct name" do
    slots.name.should == "slots"
  end
  
  it "should all be valid times" do
    slots.value.each { |slot| slot.should be_kind_of(String) }
  end
  
  it "should have the correct start time" do
    slots.value.first.should eq("06:40")
  end
  
  it "should have the correct finish time" do
    slots.value.last.should eq("22:00")
  end
  
  it "should have the correct slot length" do
   slots.value.each_with_index do |item, index|
     (Time.parse(slots.value[index]) - Time.parse(slots.value[index-1])).should eq(40.minutes) unless index == 0
   end
  end
  
  it "should create configuration" do
   slots.value.should eq(Rails.configuration.slots)
  end
end