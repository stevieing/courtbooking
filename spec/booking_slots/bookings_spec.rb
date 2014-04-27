require 'spec_helper'

describe BookingSlots::Bookings do

  before(:each) do
    stub_settings
  end

  let!(:user)         { create(:member) }
  let(:properties)    { build(:properties, date: Date.today+1, user: user) }
  let!(:other_user)   { create(:member) }
  let!(:courts)       { create_list(:court_with_opening_and_peak_times, 4) }
  let(:todays_courts) { build(:courts) }

  describe '#bookings' do

    let!(:booking1)   { create(:booking, date_from: Date.today+1, court_id: courts.first.id, user: user, time_from: "17:00", time_to: "17:40") }
    let!(:booking2)   { create(:booking, date_from: Date.today+1, court_id: courts.last.id, user: other_user, time_from: "17:00", time_to: "17:40") }
    let!(:booking3)   { create(:booking, date_from: Date.today+2, court_id: courts.first.id, user: user, time_from: "17:00", time_to: "17:40") }
    let(:bookings)    { BookingSlots::Bookings.new(properties) }
    it                { expect(bookings).to be_valid }

    it { expect(bookings.all.count).to eq(2) }

    let(:todays_slots) { build(:todays_slots)}

    describe '#current_record' do

      context 'previously booked' do

        before(:each) do
          allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:00", "17:40"))
        end

        subject { bookings.current_record(todays_courts, todays_slots) }

        it { expect(subject).to eq(booking1) }
      end

      context 'new booking' do

        before(:each) do
          allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:40", "18:20"))
        end

        subject { bookings.current_record(todays_courts, todays_slots) }

        its(:new_record?)   { should be_true }
        its(:date_from)     { should eq(Date.today+1) }
        its(:time_from)     { should eq("17:40") }
        its(:time_to)       { should eq("18:20") }

      end
    end
  end

end