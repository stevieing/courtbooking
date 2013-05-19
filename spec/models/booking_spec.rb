require 'spec_helper'

describe Booking do
  
  before(:all) do
    create_settings :days_that_can_be_booked_in_advance, :max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time 
  end
  
  before(:each) do
    DateTime.stub(:now).and_return(DateTime.parse("16 Sep 2013 17:00"))
  end
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:court_number) }
  it { should validate_presence_of(:booking_date_and_time) }
  it { should have_db_column(:opponent_user_id).of_type(:integer).with_options(null: true) }
  
  context "date before today" do
    it { should_not allow_value("16 Sep 2013 16:59").for(:booking_date_and_time) }
    it { should_not allow_value("13 Sep 2013 17:00").for(:booking_date_and_time) }
  end
  
  context "date after number of days courts can be booked in advance" do
    it { should_not allow_value("09 Oct 2013 17:01").for(:booking_date_and_time) }
    it { should_not allow_value("10 Oct 2013 17:00").for(:booking_date_and_time) }
  end
  
  describe "during peak hours" do
    
    before(:each) do
      create(:booking, court_number: 1, booking_date_and_time: "17 Sep 2013 19:00")
      create(:booking, court_number: 2, booking_date_and_time: "18 Sep 2013 17:40")
      create(:booking, court_number: 3, booking_date_and_time: "19 Sep 2013 19:00")
    end

    it "exceeds maximum number of bookings for a week" do
      build(:booking, court_number: 4, booking_date_and_time: "17 Sep 2013 19:00").should_not be_valid
    end
     
     it "extra booking created in a new week" do
       build(:booking, court_number: 3, booking_date_and_time: "24 Sep 2013 19:00").should be_valid
     end
     
     it "extra booking created outside peak hours" do
       build(:booking, court_number: 3, booking_date_and_time: "18 Sep 2013 12:00").should be_valid
     end
     
   end
   
   describe "duplicate bookings" do
     
      before(:each) do
        create(:booking, court_number: 1, booking_date_and_time: "17 Sep 2013 19:00")
      end

      it "for the same court with identical date and time" do
        build(:booking, court_number: 1, booking_date_and_time: "17 Sep 2013 19:00").should_not be_valid
      end

      it "for the same court with a different date and time" do
        build(:booking, court_number: 1, booking_date_and_time: "18 Sep 2013 19:00").should be_valid
      end

      it "for a different court with identical date and time" do
        build(:booking, court_number: 2, booking_date_and_time: "17 Sep 2013 19:00").should be_valid
      end
    end
    
    describe "destroy booking" do
      
      let!(:booking) {create(:booking, court_number: 1, booking_date_and_time: "17 Sep 2013 19:00") }
      
      it "before the booking starts" do
        booking.destroy.should be_true
      end
      
      it "after the booking starts" do
        DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:30"))
        booking.destroy.should be_false
      end
      
    end

end
