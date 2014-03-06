require "spec_helper"

describe BookingSlots::Table do

	before(:each) do
		stub_settings
		create_standard_permissions
		Date.stub(:today).and_return(Date.parse("24 February 2014"))
	end

	let(:options)					{ { slot_first: "07:00", slot_last: "17:00", slot_time: 30} }
	let(:court_slots)			{ build(:court_slots, options: options) }
	let!(:courts)         { create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "07:00", opening_time_to: "17:00") }
	let!(:edit_bookings)	{ create(:bookings_edit)}
	let!(:user)						{ create(:user) }
	let!(:other_user)			{ create(:user) }
	let!(:opponent)				{ create(:user) }

	subject { BookingSlots::Table.new(Date.today+1, user, court_slots) }

	it 						{ should be_instance_of(BookingSlots::Table) }
	it 						{ expect(subject.rows).to have(23).items }
	its(:heading)	{ should eq((Date.today+1).to_s(:uk))}

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

	#  	 		0				1 					2 					3 					4					5
	# ----------------------------------------------------------------
 	# 0	 					Court ? 		Court ? 		Court ? 		Court ?
 	# ----------------------------------------------------------------
 	# 1 	07:00																									07:00
 	# ----------------------------------------------------------------
 	# 2 	07:30																									07:30
 	# ----------------------------------------------------------------
 	# 3		08:00		BOOKING1																			08:00
 	# ---------------------------------------------------------------- CURRENT TIME
 	# 4		08:30																									08:30
 	# ----------------------------------------------------------------
 	# 5		09:00		EVENT1			EVENT1		BOOKING6								09:00
 	# ----------------------------------------------------------------
 	# 6		09:30		EVENT1			EVENT1														09:30	
 	# ----------------------------------------------------------------
 	# 7		10:00		EVENT1			EVENT1														10:00			
 	# ----------------------------------------------------------------												
 	# 8		10:30																									10:30
 	# ----------------------------------------------------------------
 	# 9		11:00															BOOKING2						11:00
 	# ----------------------------------------------------------------
 	# 10	11:30															EVENT2		EVENT2		11:30
 	# ----------------------------------------------------------------
 	# 11	12:00															EVENT2		EVENT2		12:00
 	# ----------------------------------------------------------------
 	# 12 	12:30																									12:30
 	# ----------------------------------------------------------------	
 	# 13	13:00																									13:00
 	# ----------------------------------------------------------------
 	# 14 	13:30		CLOSURE1 		CLOSURE1			CLOSURE1						13:30
 	# ----------------------------------------------------------------
 	# 15 	14:00		CLOSURE1		CLOSURE1			CLOSURE1						14:00
 	# ---------------------------------------------------------------- START OF PEAK HOURS
 	# 16 	14:30																									14:30
 	# ----------------------------------------------------------------
 	# 17 	15:00								BOOKING3													15:00
 	# ----------------------------------------------------------------
 	# 18 	15:30																				BOOKING4 	15:30
 	# ---------------------------------------------------------------- END OF PEAK HOURS
 	# 19 	16:00																									16:00
 	# ----------------------------------------------------------------
 	# 20 	16:30															BOOKING5						16:30
 	# ----------------------------------------------------------------
 	# 21	17:00																				BOOKING7	17:00
 	# ----------------------------------------------------------------
 	# 22	 				Court ? 		Court ? 			Court ? 		Court ?
 	#

 	#
 	# This might seem excessive and not very DRY however I think it is necessary to check that the table works correctly.
 	# There will be no need for extensive cucumber tests.
 	# It highlighed a bug in my logice elsewhere
 	# and gives me complete confidence in my module.
 	#

 	describe "complete table" do

 		let!(:booking1) { create(:booking, user: user, opponent: nil, playing_on: Date.today+1, time_from: "08:00", time_to: "08:30", court_number: courts.first.number)}
 		let!(:booking2) { create(:booking, user: user, opponent: nil, playing_on: Date.today+1, time_from: "11:00", time_to: "11:30", court_number: courts[2].number)}
 		let!(:booking3) { create(:booking, user: user, opponent: opponent, playing_on: Date.today+1, time_from: "15:00", time_to: "15:30", court_number: courts[1].number)}
 		let!(:booking4) { create(:booking, user: opponent, playing_on: Date.today+1, time_from: "15:30", time_to: "16:00", court_number: courts[3].number)}
 		let!(:booking5) { create(:booking, user: other_user, playing_on: Date.today+1, time_from: "16:30", time_to: "17:00", court_number: courts[2].number)}

 		let(:booking6)	{ build(:booking, playing_on: Date.today+1, time_from: "09:00", time_to: "09:30", court_number: courts[2].number) }
 		let(:booking7)	{ build(:booking, playing_on: Date.today+1, time_from: "17:00", time_to: "17:30", court_number: courts.last.number) }

 		let!(:event1)		{ create(:event, description: "event1", date_from: Date.today+1, date_to: Date.today+2, time_from: "09:00", time_to: "10:30", court_ids: [courts.first.id,courts[1].id])}
 		let!(:event2)		{ create(:event, description: "event2", date_from: Date.today+1, date_to: Date.today+2, time_from: "11:30", time_to: "12:30", court_ids: [courts[2].id,courts.last.id])}

 		let!(:closure1)	{ create(:closure, description: "closure1", date_from: Date.today+1, date_to: Date.today+2, time_from: "13:30", time_to: "14:30", court_ids: [courts.first.id, courts[1].id, courts[2].id])}

 		before(:each) do
 			allow(Time).to receive(:now).and_return(Time.parse("#{(Date.today+1).to_s(:uk)} 08:30"))
 			allow(DateTime).to receive(:now).and_return(DateTime.parse("#{(Date.today+1).to_s(:uk)} 08:30"))
 			user.permissions.create(allowed_action: edit_bookings)
 		end

 		subject { BookingSlots::Table.new(Date.today+1, user, court_slots) }

 		it { expect(Booking.count).to eq(5) }
 		it { expect(Event.count).to eq(2) }
 		it { expect(Closure.count).to eq(1)}

 		it { expect(cell(1,1)).to have_text(' ') }	
 		it { expect(cell(1,1)).to_not be_a_link }
 		it { expect(cell(3,1)).to have_text(booking1.players) }
 		it { expect(cell(3,1)).to_not be_a_link }
 		it { expect(cell(5,1)).to have_text(event1.description) }
 		it { expect(cell(5,1)).to_not be_a_link }
 		it { expect(cell(5,1)).to have_a_span_of(3) }
 		it { expect(cell(5,2)).to have_text(event1.description) }
 		it { expect(cell(5,2)).to have_a_span_of(3) }
 		it { expect(cell(5,3)).to have_text(booking6.link_text) }
 		it { expect(cell(5,3)).to be_a_link }
 		it { expect(cell(5,2)).to have_text(event1.description) }
 		it { expect(cell(6,1)).not_to be_valid }
 		it { expect(cell(6,2)).not_to be_valid }
 		it { expect(cell(7,1)).not_to be_valid }
 		it { expect(cell(7,2)).not_to be_valid }
 		it { expect(cell(8,1)).to be_valid }
 		it { expect(cell(9,3)).to have_text(booking2.players) }
 		it { expect(cell(9,3)).to be_a_link }
 		it { expect(cell(10,3)).to have_text(event2.description) }
 		it { expect(cell(10,3)).to have_a_span_of(2) }
 		it { expect(cell(10,4)).to have_text(event2.description) }
 		it { expect(cell(10,4)).to have_a_span_of(2) }
 		it { expect(cell(11,3)).to_not be_valid }
 		it { expect(cell(11,3)).to_not be_valid }
 		it { expect(cell(14,1)).to have_text(closure1.description) }
 		it { expect(cell(14,2)).to have_text(closure1.description) }
 	  it { expect(cell(14,3)).to have_text(closure1.description) }
 	  it { expect(cell(15,1)).to_not be_valid }
 		it { expect(cell(15,2)).to_not be_valid }
 	  it { expect(cell(15,3)).to_not be_valid }
 		it { expect(cell(17,2)).to have_text(booking3.players) }
 		it { expect(cell(17,2)).to be_a_link }
 		it { expect(cell(18,4)).to have_text(booking4.players) }
 		it { expect(cell(18,4)).not_to be_a_link }
 		it { expect(cell(20,3)).to have_text(booking5.players) }
 		it { expect(cell(20,3)).to_not be_a_link }
 		it { expect(cell(21,4)).to have_text(booking7.link_text) }
 	 	it { expect(cell(21,4)).to be_a_link }
 		
	end 	

end