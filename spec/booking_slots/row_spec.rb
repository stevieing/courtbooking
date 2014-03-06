require "spec_helper"

describe BookingSlots::Row do
  
  subject { BookingSlots::Row.new }

  it { expect(subject).to be_instance_of(BookingSlots::Row)}
  its(:heading?) 	{ should be_false }
  its(:count) 		{ should eq(0) }

  describe BookingSlots::HeaderRow do

  	let(:courts)			{ build_list(:court, 4) }
  	subject       		{ BookingSlots::HeaderRow.new(courts)}

  	its(:heading?)		{ should be_true }

  	it { expect(subject.first.text).to eq("&nbsp;")}
  	it { expect(subject.last.text).to eq("&nbsp;")}
  	it { expect(subject.count).to eq(courts.count+2)}
    it { expect(subject.klass).to be_nil }
    it { should be_valid }
  	
  	it { expect(courts.any? { |court| subject.each { |cell| cell.text == "Court #{court.number}" } } ).to be_true}
  
  end

  describe BookingSlots::SlotRow do

    let!(:courts)       { create_list(:court, 4) }
    let(:records)       { build(:records) }
    let(:todays_slots)  { build(:todays_slots, records: records) }

    subject { BookingSlots::SlotRow.new(todays_slots, records) }

    it { should be_valid }
    it { expect(subject.first.text).to eq(todays_slots.current_slot_time) }
    it { expect(subject.last.text).to eq(todays_slots.current_slot_time) }
    it { expect(subject.count).to eq(records.courts.count+2)}
    it { expect(records.courts.end?).to be_false }

    describe "multiple rows" do
      before(:each) do
        @row1 = BookingSlots::SlotRow.new(todays_slots, records)
        @row2 = BookingSlots::SlotRow.new(todays_slots, records)
      end

      it { expect(@row1).to be_valid }
      it { expect(@row2).to be_valid }
      it { expect(@row2.count).to eq(records.courts.count+2)}
    end

    describe 'not synced' do

      before(:each) do
        todays_slots.grid[0].up
      end

      it { should be_valid }
      it { expect(subject.count).to eq(records.courts.count+2) }
      it { expect(subject[1]).to be_instance_of(BookingSlots::NullCell) }
    end

    describe 'in the past' do

      subject { BookingSlots::SlotRow.new(todays_slots, records) }

      before(:each) do
        allow(DateTime).to receive(:now).and_return(todays_slots.current_time + 30.minutes)
      end

      it { expect(subject.klass).to eq("past")}
    end

    describe 'valid cell' do

      let(:new_cell) { build(:cell)}

      before(:each) do
        allow_any_instance_of(BookingSlots::CellBuilder).to receive(:add).and_return(new_cell)
      end

      it { expect(courts.all? { |court| subject.each { |cell| cell == new_cell unless (cell == subject.first || cell == subject.last) } }).to be_true }
    end


  end

end