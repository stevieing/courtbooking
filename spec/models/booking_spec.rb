require 'spec_helper'

describe Booking do
  
  before(:all) do
    create_settings :days_bookings_can_be_made_in_advance, :max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time 
  end
  
  after(:all) do
    Setting.delete_all
  end
  
  before(:each) do
    DateTime.stub(:now).and_return(DateTime.parse("16 Sep 2013 17:00"))
  end
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:court_number) }
  it { should validate_presence_of(:playing_at) }
  it { should have_db_column(:opponent_user_id).of_type(:integer).with_options(null: true) }
  
  context "date before today" do
    it { should_not allow_value("16 Sep 2013 16:59").for(:playing_at) }
    it { should_not allow_value("13 Sep 2013 17:00").for(:playing_at) }
  end
  
  context "date after number of days courts can be booked in advance" do
    it { should_not allow_value("09 Oct 2013 17:01").for(:playing_at) }
    it { should_not allow_value("10 Oct 2013 17:00").for(:playing_at) }
  end
  
  describe "during peak hours" do
    
    let!(:booking) { create_peak_hours_bookings(create_list(:court, 4), create(:user), DateTime.now.to_date+7, Rails.configuration.peak_hours_start_time, create(:time_slot).slot_time, Rails.configuration.max_peak_hours_bookings) }
    
    it { booking.should_not be_valid }
    it { build(:booking, court_number: 3, playing_at: "24 Sep 2013 19:00").should be_valid }
    it { build(:booking, court_number: 3, playing_at: "18 Sep 2013 12:00").should be_valid }
     
   end
   
   describe "duplicate bookings" do
     
      before(:each) do
        create(:booking, court_number: 1, playing_at: "17 Sep 2013 19:00")
      end

      it "for the same court with identical date and time" do
        build(:booking, court_number: 1, playing_at: "17 Sep 2013 19:00").should_not be_valid
      end

      it "for the same court with a different date and time" do
        build(:booking, court_number: 1, playing_at: "18 Sep 2013 19:00").should be_valid
      end

      it "for a different court with identical date and time" do
        build(:booking, court_number: 2, playing_at: "17 Sep 2013 19:00").should be_valid
      end
    end
    
    describe "destroy booking" do
      
      let!(:booking) {create(:booking, court_number: 1, playing_at: "17 Sep 2013 19:00") }
      
      it "before the booking starts" do
        booking.destroy.should be_true
      end
      
      it "after the booking starts" do
        DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:30"))
        booking.destroy.should be_false
      end
      
    end
    
    describe "scope" do
      
      let!(:booking1) {create(:booking, court_number: 1, playing_at: "17 Sep 2013 19:00") }
      let!(:booking2) {create(:booking, court_number: 2, playing_at: "17 Sep 2013 12:00") }
      let!(:booking3) {create(:booking, court_number: 2, playing_at: "18 Sep 2013 20:40") }
      let!(:booking4) {create(:booking, court_number: 3, playing_at: "17 Sep 2013 10:00") }
      
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
      
      let!(:players) {create_list(:user, 3)}
      let(:booking1) {build(:booking, user_id: players[0].id)}
      let(:booking2) {build(:booking, user_id: players[0].id, opponent_user_id: players[1].id, court_number: 2)}
      let(:booking3) {build(:booking, user_id: players[0].id, opponent_user_id: players[2].id, court_number: 3)}
      
      
      it "one player" do
        booking1.players.should == players[0].username
      end
      
      it "two players" do
        booking2.players.should == "#{players[0].username} V #{players[1].username}"
        booking3.players.should == "#{players[0].username} V #{players[2].username}"
      end
      
      
    end
    
    describe "when" do
      let!(:booking1) { create(:booking, playing_at: "17 Sep 2013 17:40") }
      let!(:booking2) { create(:booking, playing_at: "17 Sep 2013 19:40") }
      
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
    
    describe "playing_at_text" do
      let!(:booking) {create(:booking, playing_at_text: "17 September 2013 19:00")}
      let!(:booking_invalid) {build(:booking, playing_at_text: "32 September 2013 19:00")}
 
      it "populate playing_at" do
        booking.playing_at.to_s(:booking).should eq("17 September 2013 19:00")
      end
      
      it "read correctly" do
        booking.playing_at_text.should eq("17 September 2013 19:00")
      end
      
      it "validate" do
        booking_invalid.should_not be_valid
      end

    end
    
    #TODO: update playing_at_text followed by playing_at. This doesn't seem to work
    describe "update" do
      let!(:booking) {create(:booking, playing_at_text: "17 September 2013 19:00")}
      
      it "court_number" do
        booking.update_attributes(:court_number => 2).should be_false
      end
      
      it "playing_at_text" do
        booking.update_attributes(:playing_at_text => "18 September 2013 19:00").should be_false
      end

      it "opponent_user_id" do
        booking.update_attributes(:opponent_user_id => 1).should be_true
      end
      
    end
    
    describe "time_and_place" do
      
      subject {create(:booking, time_and_place: "17 September 2013 19:00, 2")}
      
      it {should be_valid}
      its(:court_number) {should eq(2)}
      its(:playing_at_text) {should eq("17 September 2013 19:00")}
    end

end
