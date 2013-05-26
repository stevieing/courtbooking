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
    
    describe "scope" do
      
      let!(:booking1) {create(:booking, court_number: 1, booking_date_and_time: "17 Sep 2013 19:00") }
      let!(:booking2) {create(:booking, court_number: 2, booking_date_and_time: "17 Sep 2013 12:00") }
      let!(:booking3) {create(:booking, court_number: 2, booking_date_and_time: "18 Sep 2013 20:40") }
      let!(:booking4) {create(:booking, court_number: 3, booking_date_and_time: "17 Sep 2013 10:00") }
      
      it "by day" do
        Booking.by_day(DateTime.parse("17 Sep 2013")).count.should == 3
      end
      
      it "by court" do
        Booking.by_day(DateTime.parse("17 Sep 2013")).by_court(2).count.should == 1
      end
      
      it "by time" do
        Booking.by_day(DateTime.parse("17 Sep 2013")).by_time(Time.parse("17 Sep 2013 12:00")).count.should == 1
      end
      
    end
    
    describe "players" do
      
      let!(:player1) {create(:user, username: "player 1")}
      let!(:player2) {create(:user, username: "player 2", email: "player2@example.com")}
      let!(:player3) {create(:user, username: "player 3", email: "player3@example.com")}
      let(:booking1) {build(:booking, user_id: player1.id)}
      let(:booking2) {build(:booking, user_id: player1.id, opponent_user_id: player2.id, court_number: 2)}
      let(:booking3) {build(:booking, user_id: player1.id, opponent_user_id: player3.id, court_number: 3)}
      
      
      it "one player" do
        booking1.players.should == "player 1"
      end
      
      it "two players" do
        booking2.players.should == "player 1 V player 2"
        booking3.players.should == "player 1 V player 3"
      end
      
      
    end
    
    describe "when" do
      let!(:booking1) { create(:booking, booking_date_and_time: "17 Sep 2013 17:40") }
      let!(:booking2) { create(:booking, booking_date_and_time: "17 Sep 2013 19:40") }
      
      before(:each) do
        DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:00"))
      end
      
      it "in the past" do
        booking1.in_the_past?.should be_true
      end
      
      it "in the future" do
        booking2.in_the_past?.should be_false
      end
    end

end
