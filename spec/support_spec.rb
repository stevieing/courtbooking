require 'spec_helper'

describe "ManageSettings" do
  
  describe "setting without attributes" do
    
    before(:each) do
      create_setting :setting_one
    end
    
    it { Rails.configuration.should.respond_to? :setting_one }

  end
  
  describe "setting with attributes as hash" do
    
    let(:setting_one) {create_setting :setting_one, {value: "setting one", description: "setting one"} }

    it { setting_one.value.should eq("setting one") }
    it { setting_one.description.should eq("setting one") }

  end
  
  describe "setting with attributes as string" do
    
    let(:setting_one) {create_setting :setting_one, "value: setting one and description: setting one"}
    
    it { setting_one.value.should eq("setting one") }
    it { setting_one.description.should eq("setting one") }

  end
  
  describe "update setting" do
    
    before(:each) do
      create_setting :setting_one
      create_setting :setting_one, {value: "2"}
    end

    it {Setting.find_by_name(:setting_one).value.should eq("2")}
  end
  
  describe "multiple settings" do
    
    before(:each) do
      create_settings :setting_one, :setting_two, :setting_three
    end
    
    it { Setting.count.should == 3}
    
    it "duplicate settings" do
      create_settings :setting_three
      Setting.count.should == 3
    end
    
  end
  
  describe "factory already defined" do
    before(:all) do
      FactoryGirl.define do
        factory :setting_one, parent: :setting do
          name "setting_one"
          value "1"
          description "setting_one"
        end
      end
    end
    
    before(:each) do
      create_setting :setting_one
    end
    
    it {Setting.find_by_name(:setting_one).value.should eq("1")}
    
    it "update" do
      create_setting :setting_one, {value: "2"}
      Setting.find_by_name(:setting_one).value.should eq("2")
    end
    
  end
end

describe "BookingsHelpers" do
  
  before(:all) do
    create_settings :days_bookings_can_be_made_in_advance, :max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time 
  end
  
  after(:all) do
    Setting.delete_all
  end
  

  
  describe "PeakHours" do
    
    before(:each) do
       DateTime.stub(:now).and_return(DateTime.parse("16 Sep 2013 17:00"))
     end

    let!(:courts) {create_list(:court, 4)}
    let!(:time_slots) {create(:time_slot)}
    let(:date) {Date.parse("16 September 2013")}
    let(:peak_hours_start_time) {Rails.configuration.peak_hours_start_time}
    let(:max_bookings) {Rails.configuration.max_peak_hours_bookings}
    let!(:user) {create(:user)}
    let!(:booking) { create_peak_hours_bookings courts, user, date, peak_hours_start_time, time_slots.slot_time, max_bookings }

    it { Booking.all.count.should == max_bookings}
    it { booking.should_not be_valid}

  end
  
  describe "CreateValidBookings" do
    
    before(:each) do
      DateTime.stub(:now).and_return(DateTime.parse("16 Sep 2013 17:00"))
    end
    
    let!(:users) {create_list(:user, 3)}
    let!(:courts) {build_list(:court, 4)}
    let(:date) {Date.parse("16 September 2013")}
    let!(:time_slots) {create(:time_slot)}
    
    before(:each) do
      create_valid_bookings([users[0], users[1]], users[2], courts, date+1, time_slots.slots)
      @bookings = Booking.all
    end
    
    it { @bookings.count.should == 4}
    it { @bookings[0].user_id.should eq(users[0].id)}
    it { @bookings[0].opponent_user_id.should be_nil}
    it { @bookings[1].user_id.should eq(users[0].id)}
    it { @bookings[1].opponent_user_id.should eq(users[2].id)}
    it { @bookings[2].user_id.should eq(users[1].id)}
    it { @bookings[2].opponent_user_id.should be_nil}
    it { @bookings[3].user_id.should eq(users[1].id)}
    it { @bookings[3].opponent_user_id.should eq(users[2].id)}
    
    
  end
  
end