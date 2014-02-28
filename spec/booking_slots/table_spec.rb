require "spec_helper"

describe BookingSlots::Table do

	before(:each) do
		Date.stub(:today).and_return(Date.parse("24 February 2014"))
	end

	let(:options)				{ { slot_first: "07:00", slot_last: "17:00", slot_time: 30}}
	let(:court_slots)		{ build(:court_slots, options: options) }
	let!(:courts)				{ create_list(:court, 4)}
	let!(:user)					{ create(:user) }

	subject { BookingSlots::Table.new(Date.today+1, user, court_slots) }

	it { should be_instance_of(BookingSlots::Table) }
	it { expect(subject.rows.count).to eq(23)}

	describe "each row" do

		it "should be of correct type" do
			subject.rows.each do |row|
				if row == subject.rows.first || row == subject.rows.last
					expect(row).to be_instance_of(BookingSlots::HeaderRow)
				else
					expect(row).to be_instance_of(BookingSlots::SlotRow)
				end
			end
		end

	end

	describe "two tables" do
		before(:each) do
			@table1 = BookingSlots::Table.new(Date.today+1, user, court_slots)
			@table2 = BookingSlots::Table.new(Date.today+1, user, court_slots)
		end

		it { expect(@table2.rows.count).to eq(23) }
	end
	
	#TODO: how do I test the closures in one place.
	describe "closures" do

		before(:each) do
			allow(Settings).to receive(:slots).and_return(CourtSlots.new(options))
			BookingSlots::Unavailable.any_instance.stub(:get_closures).and_return([create(:closure, date_from: Date.today+1, court_ids: Court.pluck(:id), date_to: Date.today+2, time_from: "12:00", time_to: "15:00")])
		end

		subject { BookingSlots::Table.new(Date.today+1, user, court_slots)}

		it { expect(subject.rows.count).to eq(17)}
		it { expect(subject.closure_message).to_not be_empty}

	end

end