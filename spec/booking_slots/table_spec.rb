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
	
	describe "closures" do

		before(:each) do
			allow(Settings).to receive(:slots).and_return(CourtSlots.new(options))
			BookingSlots::Unavailable.any_instance.stub(:get_closures).and_return([create(:closure, date_from: Date.today+1, court_ids: Court.pluck(:id), date_to: Date.today+2, time_from: "12:00", time_to: "15:00")])
		end

		subject { BookingSlots::Table.new(Date.today+1, user, court_slots)}

		it { expect(subject.rows.count).to eq(17)}
		it { expect(subject.closure_message).to_not be_empty}

	end

	#  	 						0 					1 					2 					3
	# ----------------------------------------------------------------
 	# 	 					Court 1 		Court 2 		Court 3 		Court 4
 	# ----------------------------------------------------------------
 	# 0 	07:00																									07:00
 	# ----------------------------------------------------------------
 	# 1 	07:30																									07:30
 	# ----------------------------------------------------------------
 	# 2		08:00		BOOKING1																			08:00
 	# ---------------------------------------------------------------- CURRENT TIME
 	# 3		08:30																									08:30
 	# ----------------------------------------------------------------
 	# 4		09:00		EVENT1			EVENT1														09:00
 	# ----------------------------------------------------------------
 	# 5		09:30		EVENT1			EVENT1														09:30	
 	# ----------------------------------------------------------------
 	# 6		10:00		EVENT1			EVENT1														10:00			
 	# ----------------------------------------------------------------												
 	# 7		10:30																									10:30
 	# ----------------------------------------------------------------
 	# 8		11:00															BOOKING2						11:00
 	# ----------------------------------------------------------------
 	# 9		11:30															EVENT2		EVENT2		11:30
 	# ----------------------------------------------------------------
 	# 10	12:00															EVENT2		EVENT2		12:00
 	# ----------------------------------------------------------------
 	# 11 	12:30																									12:30
 	# ----------------------------------------------------------------	
 	# 12	13:00																									13:00
 	# ----------------------------------------------------------------
 	# 13 	13:30		CLOSURE1 		CLOSURE1			CLOSURE1						13:30
 	# ----------------------------------------------------------------
 	# 14 	14:00		CLOSURE1		CLOSURE1			CLOSURE1						14:00
 	# ---------------------------------------------------------------- START OF PEAK HOURS
 	# 15 	14:30																									14:30
 	# ----------------------------------------------------------------
 	# 16 	15:00								BOOKING3													15:00
 	# ----------------------------------------------------------------
 	# 17 	15:30																				BOOKING4 	15:30
 	# ---------------------------------------------------------------- END OF PEAK HOURS
 	# 18 	16:00																									16:00
 	# ----------------------------------------------------------------
 	# 19 	16:30															BOOKING5						16:30
 	# ----------------------------------------------------------------
 	# 20	17:00																									17:00
 	# ----------------------------------------------------------------
 	# 	 					Court 1 		Court 2 			Court 3 		Court 4
 	#

 	describe "complete table" do
 	  
 	end



end