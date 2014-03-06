require 'spec_helper'

describe BookingSlots::Records do

	before(:each) do
		Date.stub(:today).and_return(Date.parse("24 February 2014"))
	end

	let(:options)				{ { slot_first: "07:00", slot_last: "17:00", slot_time: 30}}
	let(:court_slots)		{ build(:court_slots, options: options) }
	let!(:courts)				{ create_list(:court, 4)}
	let!(:courts) 			{ create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "08:00", opening_time_to: "17:00" )}
	let!(:user)					{ create(:user) }
	let(:date)					{ Date.today }
	let(:properties)		{ build(:properties, date: date, user: user)}

	before(:each) do
		Settings.stub(:slots).and_return(CourtSlots.new(options))
	end

	subject { BookingSlots::Records.new(properties) }

	it { should be_instance_of(BookingSlots::Records) }
	it { expect(subject.courts.count).to eq(4)}
	it { expect(subject.unavailable.count).to eq(0)}
	it { expect(subject.closure_message).to be_empty }

	describe "with total closures" do

		let!(:closure) 			{ create(:closure, date_from: date+1, court_ids: Court.pluck(:id), date_to: Date.today+2, time_from: "12:00", time_to: "15:00")}
		let(:properties)		{ build(:properties, date: date+1, user: user) }
		subject 						{ build(:records, properties: properties)}

		it { expect(subject.closure_message).to eq(closure.message) }
		it { expect(subject.unavailable.count).to eq(1)}

		describe '#remove_closed_slots' do

			it { expect{subject.remove_closed_slots!(court_slots)}.to change{court_slots.count}.from(21).to(15) }
		  
		end

	end

	describe "with bookings" do

		before(:each) do
			stub_settings
		end
		
		let!(:booking)		{ create(:booking, playing_on: date+1) }
		let(:properties)	{ build(:properties, date: date+1) }
		subject 					{ build(:records, properties: properties)}

		it { expect(subject.bookings.all.count).to eq(1)}

	end

	describe 'with activities' do

		let!(:event)			{ create(:event, date_from: date+1, date_to: date+1) }
		let!(:closure)		{ create(:closure, date_from: date+1, date_to: date+1)}
		let(:properties)	{ build(:properties, date: date+1) }
		subject 					{ build(:records, properties: properties)}

		it { expect(subject.events.count).to eq(1) }
		it { expect(subject.closures.count).to eq(1) }

	end

	describe '#current_record' do

		let(:activity)					{ build(:activity) }
		let(:booking)						{ build(:booking) }
		let(:todays_slots)			{ build(:todays_slots) }
		let(:current_activity)	{ build(:current_record) }
		let(:current_booking)		{ build(:current_record) }

		context 'activity' do

			before(:each) do
				allow(subject.activities).to receive(:current_record).with(subject.courts, todays_slots).and_return(current_activity)
			end

			it { expect(subject.current_record(todays_slots)).to eq(current_activity)}
			
		end

		context 'activity' do

			before(:each) do
				allow(subject.activities).to receive(:current_record).with(subject.courts, todays_slots).and_return(nil)
				allow(subject.bookings).to receive(:current_record).with(subject.courts, todays_slots).and_return(current_booking)
			end

			it { expect(subject.current_record(todays_slots)).to eq(current_booking)}
			
		end

		# this should never happen but we need to test it
		context 'nil' do

			before(:each) do
				allow(subject.activities).to receive(:current_record).with(subject.courts, todays_slots).and_return(nil)
				allow(subject.bookings).to receive(:current_record).with(subject.courts, todays_slots).and_return(nil)
			end

			it { expect(subject.current_record(todays_slots)).to eq(nil)}
		end

	end

	describe '#current_court_open?' do

		let(:todays_slots)			{ build(:todays_slots) }

		context 'court closed' do
			before(:each) do
				allow(todays_slots).to receive(:current_slot_time).and_return("07:00")
			end

			it {expect(subject.current_court_open?(todays_slots)).to be_false }

		end

		context 'court open' do
			before(:each) do
				allow(todays_slots).to receive(:current_slot_time).and_return("12:00")
			end

			it {expect(subject.current_court_open?(todays_slots)).to be_true }
			
		end

	end

end