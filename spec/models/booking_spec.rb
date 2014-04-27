#booking spec
require 'spec_helper'

describe Booking do

  before(:each) do
    stub_dates("16 September 2013", "09:00")
    create_settings_constant
    Settings.stub(:days_bookings_can_be_made_in_advance).and_return(15)
    Settings.stub(:max_peak_hours_bookings_weekly).and_return(2)
    Settings.stub(:max_peak_hours_bookings_daily).and_return(1)
  end

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:court_id) }
  it { should validate_presence_of(:date_from)}
  it { should validate_presence_of(:time_from)}
  it { should validate_presence_of(:time_to)}

  it { should have_db_column(:opponent_id).of_type(:integer).with_options(null: true) }
  it { should have_db_column(:opponent_name).of_type(:string).with_options(null: true) }
  it { should_not allow_value(Date.today-1).for(:date_from)}

  it_behaves_like "time formats", :time_from, :time_to

  it { should belong_to(:user)}
  it { should belong_to(:opponent)}
  it { should belong_to(:court)}

  it {should have_readonly_attribute(:court_id)}
  it {should have_readonly_attribute(:date_from)}
  it {should have_readonly_attribute(:time_from)}
  it {should have_readonly_attribute(:time_to)}

  it { should_not allow_value(Date.today + 16).for(:date_from) }
  it { should_not allow_value(Date.today + 15).for(:date_from) }

  let!(:courts) { create_list(:court_with_opening_and_peak_times, 4) }

  context "time in the past" do

    subject {build(:booking, court: courts.first, date_from: "16 September 2013", time_from: "18:20")}

    before(:each) do
      stub_dates("16 September 2013", "19:00")
    end

    it { should_not be_valid }
  end

  describe "during peak hours" do

    let(:court)        { courts.first }
    let(:time_from)     { court.peak_times.first.time_from }
    let(:time_to)       { time_from.time_step(30) }
    let!(:user)         { create(:user) }

    context "for the week" do

      before(:each) do
        create(:booking, date_from: Date.today+1, court: court, user: user, time_from: time_from, time_to: time_to)
        create(:booking, date_from: Date.today+2, court: court, user: user, time_from: time_from, time_to: time_to)
        @current_booking = Booking.new(date_from: Date.today+3, court: court, user: user, time_from: time_from, time_to: time_to)
        @current_booking.save
      end

      it { expect(@current_booking).to_not be_valid }
      it { expect(@current_booking.errors.full_messages).to include("No more than 2 bookings allowed during peak hours in the same week.")}

    end

    context "for the day" do

      before(:each) do
        create(:booking, date_from: Date.today+1, court: court, user: user, time_from: time_from, time_to: time_to)
        @current_booking = Booking.new(date_from: Date.today+1, court: court, user: user, time_from: time_to, time_to: time_to.time_step(30))
        @current_booking.save
      end

      it { expect(@current_booking).to_not be_valid }
      it { expect(@current_booking.errors.full_messages).to include("No more than 1 booking allowed during peak hours in the same day.")}

    end

  end

  describe "duplicate bookings" do

    let!(:booking) { create(:booking, court: courts.first, date_from: "17 Sep 2013", time_from: "19:00") }

    it { expect(build(:booking, court: courts.first, date_from: "17 Sep 2013", time_from: "19:00")).to_not be_valid }
    it { expect(build(:booking, court: courts.first, date_from: "18 Sep 2013", time_from: "19:00")).to be_valid}
    it { expect(build(:booking, court: courts.last, date_from: "17 Sep 2013", time_from: "19:00")).to be_valid}

   end

   describe "destroy booking" do

     let!(:booking) {create(:booking, court: courts.first, date_from: "17 Sep 2013", time_from: "19:00") }

     it "before the booking starts" do
       booking.destroy.should be_true
     end

     it "after the booking starts" do
      stub_dates("17 Sep 2013", "19:30")
      booking.destroy.should be_false
     end

   end

   describe "scope" do

     let!(:booking1) {create(:booking, court: courts.first, date_from: "17 Sep 2013", time_from: "19:00") }
     let!(:booking2) {create(:booking, court: courts[1], date_from: "17 Sep 2013", time_from: "12:00") }
     let!(:booking3) {create(:booking, court: courts[1], date_from: "18 Sep 2013", time_from: "20:40") }
     let!(:booking4) {create(:booking, court: courts[2], date_from: "17 Sep 2013", time_from: "10:00") }

     it { expect(Booking.by_day(Date.parse("17 Sep 2013"))).to have(3).items}
     it { expect(Booking.by_day(Date.parse("17 Sep 2013")).by_court(2)).to have(1).item}
     it { expect(Booking.by_day(Date.parse("17 Sep 2013")).by_time("12:00")).to have(1).item}
     it { expect(Booking.all.ordered.to_a).to eq([booking3, booking1, booking2, booking4])}
     it { expect(Booking.by_slot("19:00", 1)).to eq(booking1)}

   end

   describe "#players" do

     let!(:players)     { create_list(:user, 2) }
     let(:booking1)     { build(:booking, user_id: players[0].id, opponent_id: nil) }
     let(:booking2)     { build(:booking, user_id: players[0].id, opponent_id: players[1].id, court_id: 2) }
     let(:new_booking)  { build(:booking, user_id: nil)}

     it { expect(booking1.players).to eq(players[0].full_name)}
     it { expect(booking2.players).to eq("#{players[0].full_name} V #{players[1].full_name}")}
     it { expect(new_booking.players).to eq(" ")}

   end

   describe "#in_the_past?" do
     let!(:booking1) { create(:booking, date_from: "17 Sep 2013", time_from: "17:40") }
     let!(:booking2) { create(:booking, date_from: "17 Sep 2013", time_from: "19:40") }

     before(:each) do
      stub_dates("17 Sep 2013", "19:00")
     end

     it { expect(booking1.in_the_past?).to be_true}
     it { expect(booking2.in_the_past?).to_not be_true}

   end

    describe "#in_the_future?" do
     let!(:booking1) { create(:booking, date_from: "17 Sep 2013", time_from: "17:40") }
     let!(:booking2) { create(:booking, date_from: "17 Sep 2013", time_from: "19:40") }

     before(:each) do
      stub_dates("17 Sep 2013", "19:00")
     end

     it { expect(booking1.in_the_future?).to be_false}
     it { expect(booking2.in_the_future?).to be_true}

   end



   describe "#date_from_text" do
     let!(:booking) {create(:booking, date_from_text: "17 September 2013")}
     let!(:booking_invalid) {build(:booking, date_from_text: "32 September 2013")}

     it { expect(booking.date_from_text).to eq("17 September 2013")}
     it { expect(booking_invalid).to_not be_valid }

   end

   describe "#time_and_place" do

     subject {create(:booking, time_and_place: "17 September 2013,17:40,19:40,2")}

     it {should be_valid}
     its(:court_id) {should eq(2)}
     its(:date_from_text) {should eq("17 September 2013")}
     its(:time_from) {should eq("17:40")}
     its(:time_to) {should eq("19:40")}
     its(:time_and_place_text) {should eq("17 September 2013 at 5.40pm to 7.40pm")}

   end

   describe "#link_text" do
    let!(:court) { create(:court)}
    subject { build(:booking, court_id: court.id, date_from: "17 September 2013", time_from: "19:00")}

    its(:link_text) { should == "#{court.number} - 17 September 2013 19:00" }

   end

   describe 'new_attributes' do
    let!(:court) { create(:court)}
    subject { build(:booking, court_id: court.id, date_from: "17 September 2013", time_from: "19:00", time_to: "19:30")}

    it { expect(subject.new_attributes).to eq({"date_from" => Date.parse("17 September 2013"), "time_from" =>"19:00", "time_to" => "19:30", "court_id" => court.id})}

   end

   describe 'opponent' do
    let!(:user)     { create(:user)}
    let(:booking)   { create(:booking, date_from: Date.today+1, opponent_name: user.full_name)}

    it { expect(booking).to be_valid}
    it { expect(booking.opponent).to eq(user)}
    it { expect(booking.opponent_name).to eq(user.full_name)}
   end

end
