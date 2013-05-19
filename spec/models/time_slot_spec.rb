require 'spec_helper'

describe TimeSlot do
  
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:finish_time) }
  it { should validate_presence_of(:slot_time) }
  
  it { should validate_numericality_of(:slot_time) }
  
  it { should_not allow_value("1045").for(:start_time) }
  it { should_not allow_value("invalid start time").for(:start_time) }
  it { should_not allow_value("25:45").for(:start_time) }
  it { should_not allow_value("10:63").for(:start_time) }
  
  it { should_not allow_value("1045").for(:finish_time) }
  it { should_not allow_value("invalid finish time").for(:finish_time) }
  it { should_not allow_value("25:45").for(:finish_time) }
  it { should_not allow_value("10:63").for(:finish_time) }
  
  it { should_not allow_value(-1).for(:slot_time) }
  it { should_not allow_value(70).for(:slot_time) }
  
  describe "slot times" do
    
    let(:timeslot) {create(:time_slot)}
    
    it "should all be valid times" do
      timeslot.slots.each { |slot| slot.should be_kind_of(Time) }
    end
    
    it "should have the correct start time" do
      timeslot.slots.first.should eq(Time.parse(timeslot.start_time))
    end
    
    it "should have the correct finish time" do
      timeslot.slots.last.should eq(Time.parse(timeslot.finish_time))
    end
    
    it "should have the correct slot length" do
     timeslot.slots.each_with_index do |item, index|
       ((timeslot.slots[index] - timeslot.slots[index-1])/60).to_i.should equal(timeslot.slot_time) unless index == 0
     end
    end
   
 end
  
end
