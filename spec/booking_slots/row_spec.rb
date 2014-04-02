require "spec_helper"

describe BookingSlots::Row do

  subject { BookingSlots::Row.new }

  it { expect(subject).to be_instance_of(BookingSlots::Row)}
  its(:heading?)  { should be_false }
  its(:count)     { should eq(0) }

  describe BookingSlots::HeaderRow do

    context 'courts' do

      let!(:courts)        { create_list(:court_with_opening_and_peak_times, 4) }
      let(:todays_courts)  { BookingSlots::Courts.new(build(:properties)) }
      subject              { BookingSlots::HeaderRow.new(todays_courts.header)}

      its(:heading?)    { should be_true }

      it { expect(subject).to have(courts.count+2).items }
      it { expect(subject.klass).to be_nil }
      it { should be_valid }

      it { expect(courts.any? { |court| subject.each { |cell| cell.text == "Court #{court.number}" } } ).to be_true}

    end

    context 'dates' do

      let(:dates)   { build(:dates) }
      subject       { BookingSlots::HeaderRow.new(dates.header) }

      its(:heading?)  { should be_true }
      it { expect(subject).to have(dates.split).items }
      it { expect(subject.first).to have_text(dates.header.first)}
    end


  end

  describe BookingSlots::SlotRow do

    let!(:courts)       { create_list(:court_with_opening_and_peak_times, 4) }
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


    describe 'klass' do

      subject { BookingSlots::SlotRow.new(todays_slots, records) }

      context ' in the past' do

        before(:each) do
          allow(DateTime).to receive(:now).and_return(todays_slots.current_datetime + 30.minutes)
        end

        it { expect(subject.klass).to eq("past")}
      end

      context 'in the future' do

        context 'today' do
          before(:each) do
            allow(DateTime).to receive(:now).and_return(todays_slots.current_datetime - 30.minutes)
          end

          it { expect(subject.klass).to be_nil}

        end

        context 'tomorrow' do
           before(:each) do
              allow(DateTime).to receive(:now).and_return(todays_slots.current_datetime - 1.day + 30.minutes)
            end

            it { expect(subject.klass).to be_nil}
        end

      end

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