require 'spec_helper'

describe BookingSlots::CellBuilder do

  # before(:each) do
  #   Date.stub(:today).and_return(Date.parse("24 February 2014"))
  #   DateTime.stub(:now).and_return(DateTime.parse("24 February 2014 09:00"))
  #   Time.stub(:now).and_return(Time.parse("24 February 2014 09:00"))
  #   Settings.stub(:days_bookings_can_be_made_in_advance).and_return(15)
  #   Settings.stub(:max_peak_hours_bookings_weekly).and_return(2)
  #   Settings.stub(:max_peak_hours_bookings_daily).and_return(1)
  # end

  let(:date)            { Date.today+1}
  let(:options)         { { slot_first: "07:00", slot_last: "17:00", slot_time: 30}}
  let(:court_slots)     { build(:court_slots, options: options) }
  #let!(:user)           { create(:user)}
  #let!(:other_user)     { create(:user)}
  let(:properties)      { build(:properties, date: date)}
	let!(:courts)         { create_list(:court, 4) }
  let(:records)         { build(:records, properties: properties) }
  let(:todays_slots)    { build(:todays_slots, records: records) }

  subject 						{ BookingSlots::CellBuilder.new(todays_slots, records)}

  it 					{ should be_valid}
  its(:cell)	{ should be_instance_of(BookingSlots::Cell) }

  it 'find current record' do
    expect(records).to receive(:current_record).with(records.courts, todays_slots)
    BookingSlots::CellBuilder.new(todays_slots, records)
  end

 	describe 'not synced' do

    before(:each) do
      todays_slots.grid[0].up
    end

    it { expect(subject.cell).to be_instance_of(BookingSlots::NullCell) }
  end

  describe 'with a current event' do
    let(:index)           { todays_slots.grid[0].index }
    let!(:event)          { create(:event, description: "A crappy event.", date_from: date, date_to: date, time_from: "12:00", time_to: "15:00")}
    let(:records)         { build(:records, properties: properties) }
    let(:todays_slots)    { build(:todays_slots, records: records) }
    subject               { BookingSlots::CellBuilder.new(todays_slots, records).cell }

    before(:each) do
      allow(Settings).to receive(:slots).and_return(CourtSlots.new(options))
      records.stub(:current_record).and_return(event)
    end

    it            { expect(records.courts.index).to eq(0)}
    it            { expect(subject).to be_instance_of(BookingSlots::Cell) }
    its(:text)    { should eq("A crappy event.")}
    its(:span)    { should eq(event.slot.between)}
    it            { expect{BookingSlots::CellBuilder.new(todays_slots, records).cell}.to change{todays_slots.grid[0].index}.from(0).to(6) }

  end

end