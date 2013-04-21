require 'spec_helper'

describe TimeSlot do

  describe "time slots" do
    
    subject {create(:time_slot)}
    
    context "with valid attributes" do
      
      it {should be_valid}

      its(:start_time)  {should_not be_blank}
      its(:finish_time) {should_not be_blank}
      its(:slot_time)   {should_not be_blank}
      its(:slots)       {should_not be_nil}
    end
    
    describe "with invalid start time should not be valid" do
      
      let(:timeslot) {create(:time_slot)}
      
      it "when it is nil" do
        timeslot.update_attributes(start_time: nil).should be_false
      end
      
      it "when it is not a valid format (hhmm)" do
        timeslot.update_attributes(start_time: "1045").should be_false
      end
      
      it "when it is a string" do
        timeslot.update_attributes(start_time: "invalid start time").should be_false
      end
      
      it "when it is outside of normal range"  do
        timeslot.update_attributes(start_time: "25:45").should be_false
        timeslot.update_attributes(start_time: "10:63").should be_false
      end
   end
   
   describe "with invalid finish time should not be valid" do
     
     let(:timeslot) {create(:time_slot)}
     
     it "when it is nil" do
       timeslot.update_attributes(finish_time: nil).should be_false
     end
     
     it "when it is not a valid format (hhmm)" do
       timeslot.update_attributes(finish_time: "1045").should be_false
     end
     
     it "when it is a string" do
       timeslot.update_attributes(finish_time: "invalid finish time").should be_false
     end
     
     it "when it is outside of normal range"  do
       timeslot.update_attributes(finish_time: "25:45").should be_false
       timeslot.update_attributes(finish_time: "10:63").should be_false
     end
  end
  
  describe "with invalid slot time should not be valid" do
    
    let(:timeslot) {create(:time_slot)}
    
    it " when it is nil" do
      timeslot.update_attributes(slot_time: nil).should be_false
    end
    
    it " when it is below 0" do
      timeslot.update_attributes(slot_time: -1).should be_false
    end
    
    it " when it is greater than 60" do
      timeslot.update_attributes(slot_time: 70).should be_false
    end
    
    it " when it is not a number" do
      timeslot.update_attributes(slot_time: "invalid number").should be_false
    end
  end
  
  describe " slot times" do
    
    let(:timeslot) {create(:time_slot)}
    
    it "should all be valid times" do
      timeslot.slots.each do |slot|
        slot.should be_kind_of(Time)
      end
    end
    
    it "should have the correct start time" do
      timeslot.slots.first.hour.should equal(timeslot.start_time.split(":").first.to_i)
      timeslot.slots.first.min.should equal(timeslot.start_time.split(":").last.to_i)
    end
    
    it "should have the correct finish time" do
      timeslot.slots.last.hour.should equal(timeslot.finish_time.split(":").first.to_i)
      timeslot.slots.last.min.should equal(timeslot.finish_time.split(":").last.to_i)
    end
    
    it "should have the correct slot length" do
     timeslot.slots.each_with_index do |item, index|
       unless index == 0
         ((timeslot.slots[index] - timeslot.slots[index-1])/60).to_i.should equal(timeslot.slot_time)
       end
     end
    end
    
  end
   
 end

end
