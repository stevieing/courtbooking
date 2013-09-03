require 'spec_helper'

describe Slots do
  
  describe "new slots" do

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
  
  describe "create slots" do
    
    it "should have the correct settings" do
      [:start_time, :finish_time, :slot_time].each do |attribute|
        Slots.settings.include?(attribute).should be_true
      end
    end
    
    describe "by initialize" do

      it "with complete settings" do
        create_settings :slot_time, :start_time, :finish_time
        Slots.create
        Rails.configuration.slots.should_not be_nil
      end
      
      it "with incomplete settings" do
        create_settings :slot_time, :start_time
        Setting.by_name("finish_time").should be_nil
        Slots.create
        Rails.configuration.slots.should be_nil
      end
      
    end
    
    describe "by settings" do
      
      before(:each) do
        Rails.configuration.slots = nil
        create_settings :slot_time, :start_time
      end
      
      it "with relevant setting" do
        Slots.create(create(:finish_time)).should be_kind_of(Slots)
      end
      
      it "with irrelevant setting" do
        Slots.create(create(:setting, name: "any_setting")).should_not be_kind_of(Slots)
      end
    end
      
  end
end