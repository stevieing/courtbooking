require 'spec_helper'

describe BookingSlots::Bookings do

	before(:each) do
		Date.stub(:today).and_return(Date.parse("16 September 2013"))
    DateTime.stub(:now).and_return(DateTime.parse("16 September 2013 09:00"))
    Time.stub(:now).and_return(Time.parse("16 September 2013 09:00"))
	  stub_settings
	end

	let(:properties) 		{ build(:properties, date: Date.today+1) }
	let!(:user)					{ create(:user) }
	let!(:other_user)		{ create(:user) }
	let!(:courts)				{ create_list(:court, 4) }
	let!(:booking1)	 		{ create(:booking, playing_on: Date.today+1, court_number: courts.first.number, user: user, time_from: "17:00", time_to: "17:40") }
  let!(:booking2) 		{ create(:booking, playing_on: Date.today+1, court_number: courts.last.number, user: other_user, time_from: "17:00", time_to: "17:40") }
  let!(:booking3)   	{ create(:booking, playing_on: Date.today+2, court_number: courts.first.number, user: user, time_from: "17:00", time_to: "17:40") }
  let(:todays_courts)	{ build(:courts) }

	subject         { BookingSlots::Bookings.new(properties) }
	it 							{ should be_valid }

	describe '#bookings' do

		it { expect(subject.bookings.count).to eq(2) }

		let(:todays_slots) { build(:todays_slots)}

		describe '#current_booking' do

			context 'previously booked' do

				before(:each) do
					allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:00", "17:40"))
				end

				let(:old_booking) { subject.current_booking(todays_courts, todays_slots)}

				it { expect(old_booking).to eq(booking1) }
			end

			context 'new booking' do

				before(:each) do
					allow(todays_slots).to receive(:current).and_return(Slots::Slot.new("17:40", "18:20"))
				end

				let(:new_booking) { subject.current_booking(todays_courts, todays_slots)}

				it { expect(new_booking.new_record?).to be_true}
				it { expect(new_booking.playing_on).to eq(Date.today+1)}
				it { expect(new_booking.time_from).to eq("17:40")}
				it { expect(new_booking.time_to).to eq("18:20")}

			end
		end
	end

	describe '#current_record' do


	end
end