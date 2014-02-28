require 'spec_helper'

describe BookingSlots::TodaysSlots do

	let!(:courts)				{ create_list(:court, 4)}
	let(:options)				{ { slot_first: "07:00", slot_last: "17:00", slot_time: 30}}
	let(:court_slots)		{ build(:court_slots, options: options)}
	let(:properties)		{ build(:properties, date: Date.today) }
	let(:records)				{ build(:records, properties: properties)}

	describe "#new" do

	  subject { BookingSlots::TodaysSlots.new(court_slots, records)}

	  it { should be_valid }
	  it { expect(subject.grid.frozen?).to be_true}
	  it { expect(subject.grid).to be_instance_of(Slots::Grid)}
	  it { expect(subject.grid.count).to eq(4)}

	end

	describe "total closures" do
		before(:each) do
			allow(Settings).to receive(:slots).and_return(build(:court_slots, options: options))
			allow(Court).to receive(:closures_for_all_courts).and_return([create(:closure, date_from: Date.today+1, court_ids: Court.pluck(:id), date_to: Date.today+2, time_from: "12:00", time_to: "15:00")])
		end

		subject { BookingSlots::TodaysSlots.new(court_slots, records)}

		it { expect(subject[0].count).to eq(15)}
	end

end