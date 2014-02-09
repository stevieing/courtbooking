#booking spec
require 'spec_helper'

describe Booking do
  
  before(:each) do
    Date.stub(:today).and_return(Date.parse("16 September 2013"))
    DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 09:00"))
    Time.stub(:now).and_return(Time.parse("16 September 2013 09:00"))
  end
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:court_number) }  
  it { should validate_presence_of(:playing_on)}
  it { should validate_presence_of(:playing_from)}
  it { should validate_presence_of(:playing_to)}
  
  it { should have_db_column(:opponent_id).of_type(:integer).with_options(null: true) }
  it { should have_db_column(:opponent_name).of_type(:string).with_options(null: true) }
  it { should_not allow_value(Date.today-1).for(:playing_on)}

  it_behaves_like "time formats", :playing_from, :playing_to
  
  it { should belong_to(:user)}
  it { should belong_to(:opponent)}

  it {should have_readonly_attribute(:court_number)}
  it {should have_readonly_attribute(:playing_on)}
  it {should have_readonly_attribute(:playing_from)}
  it {should have_readonly_attribute(:playing_to)}

  it { should_not allow_value(Date.today + Settings.days_bookings_can_be_made_in_advance + 1).for(:playing_on) }
  it { should_not allow_value(Date.today + Settings.days_bookings_can_be_made_in_advance).for(:playing_on) }
  
  context "time in the past" do
    
    subject {build(:booking, court_number: 1, playing_on: "16 September 2013", playing_from: "18:20")}
    
    before(:each) do
      DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 19:00"))
    end
    
    it { should_not be_valid }
  end
   
  describe "during peak hours" do
    
    let!(:court) {create(:court_with_opening_and_peak_times)}

    context "for the week" do
      
      let!(:max_bookings) { Settings.max_peak_hours_bookings_weekly}
      let!(:booking) { create_peak_hours_bookings_for_week court, create(:user), Date.today, max_bookings, Settings.slots.all}
      it { booking.should_not be_valid}
      it { Booking.all.count.should == 3}
      
    end
    
    context "for the day" do
      
      let!(:max_bookings) { Settings.max_peak_hours_bookings_daily}
      let!(:booking) { create_peak_hours_bookings_for_day court, create(:user), Date.today, max_bookings, Settings.slots.all}
      it { booking.should_not be_valid}
      it { Booking.all.count.should == 1}
      
    end
      
  end

  describe "duplicate bookings" do
    
    let!(:booking) { create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }

    it { expect(build(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00")).to_not be_valid }
    it { expect(build(:booking, court_number: 1, playing_on: "18 Sep 2013", playing_from: "19:00")).to be_valid}
    it { expect(build(:booking, court_number: 2, playing_on: "17 Sep 2013", playing_from: "19:00")).to be_valid}
    
   end
  
   describe "destroy booking" do
         
     let!(:booking) {create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }
         
     it "before the booking starts" do
       booking.destroy.should be_true
     end
         
     it "after the booking starts" do
       DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:30"))
       Time.stub(:now).and_return(Time.parse("17 Sep 2013 19:30"))
       booking.destroy.should be_false
     end
     
   end
       
   describe "scope" do

     let!(:booking1) {create(:booking, court_number: 1, playing_on: "17 Sep 2013", playing_from: "19:00") }
     let!(:booking2) {create(:booking, court_number: 2, playing_on: "17 Sep 2013", playing_from: "12:00") }
     let!(:booking3) {create(:booking, court_number: 2, playing_on: "18 Sep 2013", playing_from: "20:40") }
     let!(:booking4) {create(:booking, court_number: 3, playing_on: "17 Sep 2013", playing_from: "10:00") }

     it { expect(Booking.by_day(Date.parse("17 Sep 2013"))).to have(3).items}
     it { expect(Booking.by_day(Date.parse("17 Sep 2013")).by_court(2)).to have(1).item}
     it { expect(Booking.by_day(Date.parse("17 Sep 2013")).by_time("12:00")).to have(1).item}
     it { expect(Booking.all.ordered.to_a).to eq([booking3, booking1, booking2, booking4])}
     it { expect(Booking.by_slot("19:00", 1)).to eq(booking1)}

   end

   describe "players" do

     let!(:players) {create_list(:user, 2)}
     let(:booking1) {build(:booking, user_id: players[0].id, opponent_id: nil)}
     let(:booking2) {build(:booking, user_id: players[0].id, opponent_id: players[1].id, court_number: 2)}

     it { expect(booking1.players).to eq(players[0].full_name)}
     it { expect(booking2.players).to eq("#{players[0].full_name} V #{players[1].full_name}")}

   end

   describe "when" do
     let!(:booking1) { create(:booking, playing_on: "17 Sep 2013", playing_from: "17:40") }
     let!(:booking2) { create(:booking, playing_on: "17 Sep 2013", playing_from: "19:40") }

     before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("17 Sep 2013 19:00"))
       Time.stub(:now).and_return(Time.parse("17 Sep 2013 19:00"))
     end

     it { expect(booking1.in_the_past?).to be_true}
     it { expect(booking2.in_the_past?).to_not be_true}

   end

   describe "playing_on_text" do
     let!(:booking) {create(:booking, playing_on_text: "17 September 2013")}
     let!(:booking_invalid) {build(:booking, playing_on_text: "32 September 2013")}

     it { expect(booking.playing_on_text).to eq("17 September 2013")}
     it { expect(booking_invalid).to_not be_valid }

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
   
   describe "link text" do
     subject { build(:booking, court_number: 1, playing_on: "17 September 2013", playing_from: "19:00")}
     
     its(:link_text) { should == "1 - 17 September 2013 19:00" }
   end

end
