require 'spec_helper'

describe BookingSlots::CellBuilder do

  let(:date)            { Date.today+1 }
  let(:options)         { { slot_first: "07:00", slot_last: "17:00", slot_time: 30} }
  let(:court_slots)     { build(:court_slots, options: options) }
  let(:properties)      { build(:properties, date: date)}
	let!(:courts)         { create_list(:court, 4) }
  let(:records)         { build(:records, properties: properties) }
  let(:todays_slots)    { build(:todays_slots, records: records) }

  subject 						  { BookingSlots::CellBuilder.new(todays_slots, records) }

  it 					{ should be_valid}
  its(:cell)	{ should be_instance_of(BookingSlots::Cell) }

  it 'find current record' do
    expect(records).to receive(:current_record).with(todays_slots)
    BookingSlots::CellBuilder.new(todays_slots, records)
  end

 	describe 'not synced' do

    before(:each) do
      todays_slots.skip(0,1)
    end

    it { expect(subject.cell).to be_instance_of(BookingSlots::NullCell) }
  end

  describe 'with a record' do
    let(:current_record)  { build(:current_record) }
    subject               { BookingSlots::CellBuilder.new(todays_slots, records).add }

    before(:each) do
      allow(records).to receive(:current_record).with(todays_slots).and_return(current_record)
    end

    its(:text)  { should eq(current_record.text)}
    its(:link)  { should eq(current_record.link)}
    its(:klass) { should eq(current_record.klass)}
    its(:span)  { should eq(current_record.span)}

    it { expect{BookingSlots::CellBuilder.new(todays_slots, records)}.to change{todays_slots.grid[0].index}.from(0).to(current_record.span) }

    context 'no current record' do

      let(:cell) { build(:cell)}

      before(:each) do
        allow(records).to receive(:current_record).with(todays_slots).and_return(nil)
      end

      its(:text)  { should eq(cell.text)}
      its(:link)  { should eq(cell.link)}
      its(:klass) { should eq(cell.klass)}
      its(:span)  { should eq(cell.span)}

      it { expect{BookingSlots::CellBuilder.new(todays_slots, records)}.to_not change{todays_slots.grid[0].index} }
    end
  end

end