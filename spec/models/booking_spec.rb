#booking spec
require 'spec_helper'

describe Booking do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end
  
  before(:each) do
    Date.stub(:today).and_return(Date.parse("16 September 2013"))
    DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 19:00"))
  end
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:court_number) }  
  it { should validate_presence_of(:playing_on)}
  it { should validate_presence_of(:playing_from)}
  it { should validate_presence_of(:playing_to)}
  
  it { should have_db_column(:opponent_id).of_type(:integer).with_options(null: true) }
  it { should_not allow_value(Date.today-1).for(:playing_on)}
  
  it { should_not allow_value("1045").for(:playing_from) }
  it { should_not allow_value("invalid playing from").for(:playing_from) }
  it { should_not allow_value("25:45").for(:playing_from) }
  it { should_not allow_value("10:63").for(:playing_from) }

  it { should_not allow_value("1045").for(:playing_to) }
  it { should_not allow_value("invalid playing to").for(:playing_to) }
  it { should_not allow_value("25:45").for(:playing_to) }
  it { should_not allow_value("10:63").for(:playing_to) }
  
  it { should belong_to(:user)}
  it { should belong_to(:opponent)}
  
  context "date after number of days courts can be booked in advance" do
    it { should_not allow_value(Date.today + Rails.configuration.days_bookings_can_be_made_in_advance + 1).for(:playing_on) }
    it { should_not allow_value(Date.today + Rails.configuration.days_bookings_can_be_made_in_advance).for(:playing_on) }
  end
  
  context "time in the past" do
    
    subject {build(:booking, court_number: 1, playing_on: "16 September 2013", playing_from: "18:20")}
    
    before(:each) do
      DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 19:00"))
    end
    
    it { should_not be_valid }
  end
   
  describe "during peak hours" do
    
    let!(:court) {create(:court_with_opening_and_peak_times)}
    let!(:booking) { create_peak_hours_bookings court, create(:user), Date.today+1, Rails.configuration.max_peak_hours_bookings}
    
    it { booking.should_not be_valid}
    it {Booking.all.count.should == 3}
      
  end

  describe "duplicate bookings" do
    
    let!(:booking) { create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }
         
    it "for the same court with identical date and time" do
      build(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00").should_not be_valid
    end
          
    it "for the same court with a different date and time" do
      build(:booking, court_number: 1, playing_on: "18 Sep 2013", playing_from: "19:00").should be_valid
    end
         
    it "for a different court with identical date and time" do
      build(:booking, court_number: 2, playing_on: "17 Sep 2013", playing_from: "19:00").should be_valid
    end
    
   end
  
   describe "destroy booking" do
         
     let!(:booking) {create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }
         
     it "before the booking starts" do
       booking.destroy.should be_true
     end
         
     it "after the booking starts" do
       DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:30"))
       booking.destroy.should be_false
     end
     
   end
       
   describe "scope" do

     let!(:booking1) {create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }
     let!(:booking2) {create(:booking, court_number: 2, playing_on: "17 Sep 2013", playing_from: "12:00") }
     let!(:booking3) {create(:booking, court_number: 2, playing_on: "18 Sep 2013", playing_from: "20:40") }
     let!(:booking4) {create(:booking, court_number: 3, playing_on: "17 Sep 2013", playing_from: "10:00") }
 
     it "by day" do
       Booking.by_day(Date.parse("17 Sep 2013")).count.should == 3
     end

     it "by court" do
       Booking.by_day(Date.parse("17 Sep 2013")).by_court(2).count.should == 1
     end

     it "by time" do
       Booking.by_day(Date.parse("17 Sep 2013")).by_time("12:00").count.should == 1
     end

   end

   describe "players" do

     let!(:players) {create_list(:user, 3)}
     let(:booking1) {build(:booking, user_id: players[0].id, opponent_id: nil)}
     let(:booking2) {build(:booking, user_id: players[0].id, opponent_id: players[1].id, court_number: 2)}
     let(:booking3) {build(:booking, user_id: players[0].id, opponent_id: players[2].id, court_number: 3)}
     
     it "one player" do
       booking1.players.should == players[0].username
     end

     it "two players" do
       booking2.players.should == "#{players[0].username} V #{players[1].username}"
       booking3.players.should == "#{players[0].username} V #{players[2].username}"
     end

   end

   describe "when" do
     let!(:booking1) { create(:booking, playing_on: "17 Sep 2013", playing_from: "17:40") }
     let!(:booking2) { create(:booking, playing_on: "17 Sep 2013", playing_from: "19:40") }

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

   describe "playing_on_text" do
     let!(:booking) {create(:booking, playing_on_text: "17 September 2013")}
     let!(:booking_invalid) {build(:booking, playing_on_text: "32 September 2013")}

     it "populate playing_on" do
       booking.playing_on.to_s(:uk).should eq("17 September 2013")
     end

     it "read correctly" do
       booking.playing_on_text.should eq("17 September 2013")
     end

     it "validate" do
       booking_invalid.should_not be_valid
     end

   end

   describe "non-editable attributes" do
     let!(:booking) {create(:booking, playing_on_text: "17 September 2013", playing_from: "19:00", playing_to: "19:40" )}

     it "court_number" do
       booking.update_attributes(:court_number => 2).should be_false
     end

     it "playing_on_text" do
       booking.update_attributes(:playing_on_text => "18 September 2013").should be_false
     end
     
     it "playing_from" do
       booking.update_attributes(:playing_from => "20:20").should be_false
     end
     
     it "playing_to" do
       booking.update_attributes(:playing_to => "20:20").should be_false
     end
     
     it "opponent_id" do
       booking.update_attributes(:opponent_id => 1).should be_true
     end
   end

   describe "time_and_place" do
     
     subject {create(:booking, time_and_place: "17 September 2013,17:40,19:40,2")}

     it {should be_valid}
     its(:court_number) {should eq(2)}
     its(:playing_on_text) {should eq("17 September 2013")}
     its(:playing_from) {should eq("17:40")}
     its(:playing_to) {should eq("19:40")}
     its(:time_and_place_text) {should eq("17 September 2013 at 5.40pm to 7.40pm")}
     
   end
   
   describe "user association" do
     
     let!(:user)    {create(:user)}
     let(:booking)  {user.bookings.build}
     
     it { booking.user.should_not be_nil}

   end
   
   describe "opponent association" do
     
     let!(:booking)  {create(:booking, playing_on: "17 September 2013")}
     let(:opponent)  {booking.opponent.build}
     
     it { booking.opponent.should_not be_nil}

   end
   
   describe "link text" do
     subject { build(:booking, court_number: 1, playing_on: "17 September 2013", playing_from: "19:00")}
     
     its(:link_text) { should == "1 - 17 September 2013 19:00" }
   end

end
