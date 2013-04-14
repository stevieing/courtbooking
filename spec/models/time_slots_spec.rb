require 'spec_helper'

describe TimeSlots do

  describe "time slots" do
    
    subject {build(:time_slots)}
    
    context " with valid attributes" do
      
      it {should be_valid}

      its(:start_time)  {should_not be_blank}
      its(:finish_time) {should_not be_blank}
      its(:slot_time)   {should_not be_blank}
      its(:slots)       {should_not be_nil}
    end
    
    describe " with invalid start time should not be valid" do
      
      let(:timeslots) {build(:time_slots)}
      
      it " when it is nil" do
        timeslots.start_time = nil
        timeslots.should_not be_valid
      end
      
      it " when it is not a valid format (hhmm)" do
        timeslots.start_time = "1045"
        timeslots.should_not be_valid
      end
      
       it " when it is a string" do
          timeslots.start_time = "invalid start time"
          timeslots.should_not be_valid
        end
      
      it " when it is outside of normal range"  do
        timeslots.start_time = "25:45"
        timeslots.should_not be_valid
        timeslots.start_time = "10:63"
        timeslots.should_not be_valid
      end
   end
   
   describe " with invalid finish time should not be valid" do
     
     let(:timeslots) {build(:time_slots)}
     
     it " when it is nil" do
       timeslots.finish_time = nil
       timeslots.should_not be_valid
     end
     
     it " when it is not a valid format (hhmm)" do
       timeslots.finish_time = "1045"
       timeslots.should_not be_valid
     end
     
      it " when it is a string" do
         timeslots.finish_time = "invalid finish time"
         timeslots.should_not be_valid
       end
     
     it " when it is outside of normal range"  do
       timeslots.finish_time = "25:45"
       timeslots.should_not be_valid
       timeslots.finish_time = "10:63"
       timeslots.should_not be_valid
     end
  end
  
  describe "with invalid slot time should not be valid" do
    
    let(:timeslots) {build(:time_slots)}
    
    it " when it is nil" do
      timeslots.slot_time = nil
      timeslots.should_not be_valid
    end
    
    it " when it is below 0" do
      timeslots.slot_time = -1
      timeslots.should_not be_valid
    end
    
    it " when it is greater than 60" do
      timeslots.slot_time = 70
      timeslots.should_not be_valid
    end
    
    it " when it is not a number" do
      timeslots.slot_time = "invalid number"
      timeslots.should_not be_valid
    end
  end
  
  describe " slot times" do
    
    let(:timeslots) {build(:time_slots)}
    
    it "should all be valid times" do
      timeslots.slots.each do |slot|
        slot.should be_kind_of(Time)
      end
    end
    
    it "should have the correct start time" do
      timeslots.slots.first.hour.should equal(timeslots.start_time.split(":").first.to_i)
      timeslots.slots.first.min.should equal(timeslots.start_time.split(":").last.to_i)
    end
    
    it "should have the correct finish time" do
      timeslots.slots.last.hour.should equal(timeslots.finish_time.split(":").first.to_i)
      timeslots.slots.last.min.should equal(timeslots.finish_time.split(":").last.to_i)
    end
    
    it "should have the correct slot length" do
     timeslots.slots.each_with_index do |item, index|
       unless index == 0
         ((timeslots.slots[index] - timeslots.slots[index-1])/60).to_i.should equal(timeslots.slot_time)
       end
     end
    end
    
  end
   
 end

end