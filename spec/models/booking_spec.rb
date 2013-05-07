require 'spec_helper'

describe Booking, :focus => true do
  
  before(:all) do
    create(:setting, name: "days_that_can_be_booked_in_advance", value: 21, description: "days")
  end

  subject {create(:booking)}
  
  context "with valid attributes" do
    
    it {should be_valid}

    its(:user_id)           {should_not be_blank}
    its(:court_number)      {should_not be_blank}
    its(:booking_datetime) {should_not be_blank}
    its(:opponent_user_id)  {should_not be_blank}
  end
  
  describe "with invalid attributes" do
    
     before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("13 Sep 2013 17:00"))
       @booking = create(:booking, booking_datetime: DateTime.parse("14 Sep 2013 17:00"))
     end

     it "no user id" do
       @booking.update_attributes(user_id: nil).should be_false
     end

     it "no court number" do
       @booking.update_attributes(court_number: nil).should be_false
     end

     it "no booking date and time" do
       @booking.update_attributes(booking_datetime: nil).should be_false
     end
     
     it "date that is before now" do
       @booking.update_attributes(booking_datetime: "13 Sep 2013 16:59").should be_false
       @booking.update_attributes(booking_datetime: "10 Sep 2013 17:00").should be_false
     end
     
     it "date that is after the number of days courts can be booked in advance" do
       @booking.update_attributes(booking_datetime: "04 Oct 2013 17:01").should be_false
       @booking.update_attributes(booking_datetime: "06 Oct 2013 17:00").should be_false
     end

   end
  
end
