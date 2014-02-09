require 'spec_helper'

describe "BookingsHelpers" do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end
  
  describe "Peak Hours" do
       
    before(:each) do
      Date.stub(:today).and_return(Date.parse("16 September 2013"))
      DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 09:00"))
    end
        
    let(:date)          { Date.today+1}
    let!(:court)        {create(:court_with_opening_and_peak_times)}
    let!(:user)         { create(:user)}
    let!(:slots)        { Settings.slots.all}
    
    context "during a week" do
      
      let(:max_bookings)  {Settings.max_peak_hours_bookings_weekly}
      let!(:booking)      {create_peak_hours_bookings_for_week court, user, date, max_bookings, slots}
   
      it { booking.should be_kind_of(Booking)}
      it {court.peak_times.find_by(:day => date.beginning_of_week.wday).time_from.should == "17:40"}
      it {booking.should_not be_valid}
      it { Booking.all.count.should == max_bookings}
    
      it "correct dates" do
        bookings = Booking.all
        (1..bookings.count-1).each do |i|
          bookings[i].playing_on.should_not == bookings[i-1].playing_on
        end
      end
    end
    
    context "for a day" do
      
      let(:max_bookings)  {Settings.max_peak_hours_bookings_daily}
      let!(:booking)      {create_peak_hours_bookings_for_day court, user, date, max_bookings, slots}
      
      it { booking.should be_kind_of(Booking)}
      it { Booking.all.count.should == 1}
      it { Booking.first.playing_on.should == booking.playing_on }
      
    end
  end
    
  describe "CreateValidBookings" do
      
    before(:each) do
      Date.stub(:today).and_return(Date.parse("16 September 2013"))
      DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 19:00"))
    end
      
    let!(:users) {create_list(:user, 3)}
    let!(:courts) {build_list(:court, 4)}
    let(:date) {Date.parse("16 September 2013")}
    let!(:slots) {Settings.slots.all}
      
    before(:each) do
      create_valid_bookings([users[0], users[1]], users[2], courts, date+1, slots)
      @bookings = Booking.all
    end
      
    it { @bookings.count.should == 4}
    it { @bookings[0].user_id.should eq(users[0].id)}
    it { @bookings[0].opponent_id.should be_nil}
    it { @bookings[1].user_id.should eq(users[0].id)}
    it { @bookings[1].opponent_id.should eq(users[2].id)}
    it { @bookings[2].user_id.should eq(users[1].id)}
    it { @bookings[2].opponent_id.should be_nil}
    it { @bookings[3].user_id.should eq(users[1].id)}
    it { @bookings[3].opponent_id.should eq(users[2].id)}
      
  end
  
end