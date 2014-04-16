require 'spec_helper'

describe BookingSlots::Properties do

  before(:each) do
    stub_settings
  end

  let!(:user)         { create(:user)}
  let!(:other_user)   { create(:user)}
  let!(:edit_action)  { create(:bookings_edit)}
  let(:date)          { Date.today}

  subject     { BookingSlots::Properties.new(date, user)}

  its(:user)  { should eq(user)}
  its(:date)  { should eq(date)}
  its(:wday)  { should eq(date.wday)}

end