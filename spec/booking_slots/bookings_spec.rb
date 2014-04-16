require 'spec_helper'

describe BookingSlots::Bookings do

  before(:each) do
    stub_settings
  end

  let(:properties)    { build(:properties, date: Date.today+1) }
  let!(:user)         { create(:user) }
  let!(:other_user)   { create(:user) }
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

    describe '#current_booking' do

      context 'previously booked' do

        before(:each) do
          allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:00", "17:40"))
        end

        subject { bookings.current_booking(todays_courts, todays_slots) }

        it { expect(subject).to eq(booking1) }
      end

      context 'new booking' do

        before(:each) do
          allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:40", "18:20"))
        end

        subject { bookings.current_booking(todays_courts, todays_slots) }

        its(:new_record?)   { should be_true }
        its(:date_from)     { should eq(Date.today+1) }
        its(:time_from)     { should eq("17:40") }
        its(:time_to)       { should eq("18:20") }

      end
    end
  end

  describe '#current_record' do

    let(:todays_slots)  { build(:todays_slots)}
    let!(:booking1)     { create(:booking, date_from: Date.today+1, court_id: courts.first.id, user: user, time_from: "17:00", time_to: "17:40") }
    let(:bookings)      { BookingSlots::Bookings.new(properties) }

    context 'previously booked' do

      before(:each) do
        allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:00", "17:40"))
        allow(todays_courts).to receive(:current).and_return(courts.first)
      end

      subject   { bookings.current_record(todays_courts, todays_slots) }

      it          { should be_instance_of(BookingSlots::CurrentRecord) }
      its(:text)  { should eq(booking1.players) }
      its(:klass) { should eq("booking") }
      its(:span)  { should eq(1) }

      context 'current user' do

        before(:each) do
          allow_any_instance_of(Permissions::BookingsPolicy).to receive(:edit?).and_return(true)
        end

        subject   { bookings.current_record(todays_courts, todays_slots) }

        its(:link) { should eq(edit_booking_path(booking1)) }

      end

      context 'another user' do

        before(:each) do
          allow_any_instance_of(Permissions::BookingsPolicy).to receive(:edit?).and_return(false)
        end

        subject   { bookings.current_record(todays_courts, todays_slots) }

        its(:link) { should be_nil }
        its(:klass) { should eq("booking") }
      end

      context 'in the past' do

        before(:each) do
          allow_any_instance_of(Permissions::BookingsPolicy).to receive(:edit?).and_return(true)
          DateTime.stub(:now).and_return(DateTime.parse("#{booking1.date_from.to_s(:uk)} 17:01"))
        end

        subject   { bookings.current_record(todays_courts, todays_slots) }

        its(:link) { should be_nil }
        its(:klass) { should eq("booking") }
      end

    end

    context 'new booking' do

      let(:new_booking) { build(:booking, date_from: Date.today+1, court_id: courts.first.id, time_from: "17:40", time_to: "18:20")}

      before(:each) do
        allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:40", "18:20"))
        allow(todays_courts).to receive(:current).and_return(courts.first)
      end

      subject     { bookings.current_record(todays_courts, todays_slots) }

      its(:text)  { should eq(new_booking.link_text)}
      its(:link)  { should eq(court_booking_path(new_booking.new_attributes))}
      its(:klass) { should be_nil }

      context 'in the past' do

        before(:each) do
          DateTime.stub(:now).and_return(DateTime.parse("#{booking1.date_from.to_s(:uk)} 17:41"))
        end

        its(:text)  { should eq(" ")}
        its(:link)  { should be_nil }

      end

    end

  end

end