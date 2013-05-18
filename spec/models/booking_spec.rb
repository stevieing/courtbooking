require 'spec_helper'

describe Booking do
  
  before(:all) do
    create_setting "days_that_can_be_booked_in_advance", "21", "Number of days that courts can be booked in advance"
    create_setting "max_peak_hours_bookings", "3", "Maximum number of bookings that can be made during peak hours"
    create_setting "peak_hours_start_time", "17:40", "Start time of peak hours"
    create_setting "peak_hours_finish_time", "19:40", "Finish time of peak hours"
  end
  
  describe "with valid attributes" do
    
    before(:each) do
      @booking = create(:booking)
    end
    
    it "should have a user id" do
      @booking.user_id.should_not be_blank
    end
    
    it "should have a court number" do
      @booking.court_number.should_not be_blank
    end
    
    it "should have a booking date and time" do
      @booking.booking_date_and_time.should_not be_blank
    end
    
    it "should have an opponent user id" do
      @booking.opponent_user_id.should_not be_blank
    end
 
  end
  
  describe "with invalid attributes" do
    
     before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("13 Sep 2013 17:00"))
       @booking = create(:booking, booking_date_and_time: "14 Sep 2013 17:00")
     end

     it "no user id" do
       @booking.update_attributes(user_id: nil).should be_false
     end

     it "no court number" do
       @booking.update_attributes(court_number: nil).should be_false
     end

     it "no booking date and time" do
       @booking.update_attributes(booking_date_and_time: nil).should be_false
     end
     
     it "date that is before now" do
       @booking.update_attributes(booking_date_and_time: "13 Sep 2013 16:59").should be_false
       @booking.update_attributes(booking_date_and_time: "10 Sep 2013 17:00").should be_false
     end
     
     it "date that is after the number of days courts can be booked in advance" do
       @booking.update_attributes(booking_date_and_time: "05 Oct 2013 17:01").should be_false
       @booking.update_attributes(booking_date_and_time: "06 Oct 2013 17:00").should be_false
     end

   end
   
   describe "during peak hours" do
     
     before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("01 September 2013 17:00"))
       create(:booking, court_number: 1, booking_date_and_time: "02 September 2013 19:00")
       create(:booking, court_number: 2, booking_date_and_time: "03 September 2013 17:40")
       create(:booking, court_number: 3, booking_date_and_time: "02 September 2013 19:00")
     end
     
     it "should not be valid if exceeds maximum number of bookings for a week" do
       build(:booking, court_number: 4, booking_date_and_time: "05 September 2013 19:00").should_not be_valid
     end
     
     it "should be valid if extra booking created in a new week" do
       build(:booking, court_number: 3, booking_date_and_time: "20 September 2013 19:00").should be_valid
     end
     
     it "should be valid if extra booking created outside peak hours" do
       build(:booking, court_number: 3, booking_date_and_time: "04 September 2013 12:00").should be_valid
     end
   end
   
   describe "duplicate bookings" do
     before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("13 September 2013 17:00"))
       create(:booking, court_number: 1, booking_date_and_time: "14 September 2013 19:00")
     end
     
     it "should not be valid if a booking is created for the same court with identical date and time" do
       build(:booking, court_number: 1, booking_date_and_time: "14 September 2013 19:00").should_not be_valid
     end
     
     it "should be valid if a booking is created for the same court with a different date and time" do
       build(:booking, court_number: 1, booking_date_and_time: "15 September 2013 19:00").should be_valid
     end
      
      it "should be valid if a booking is created for a different court with identical date and time" do
        build(:booking, court_number: 2, booking_date_and_time: "14 September 2013 19:00").should be_valid
      end
   end
  
end
