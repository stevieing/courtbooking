require 'spec_helper'

describe BookingSlots::Activities do

    let!(:courts)         { create_list(:court_with_opening_and_peak_times, 4) }
    let(:date)            { Date.today }
    let(:options)         { { slot_first: "07:00", slot_last: "17:00", slot_time: 30}}
    let!(:event)          { create(:event, date_from: date+1, date_to: date+1) }
    let!(:closure)        { create(:closure, date_from: date+1, date_to: date+1)}
    let(:properties)      { build(:properties, date: date+1) }
    let(:todays_slots)    { build(:todays_slots)}
    let(:todays_courts)   { build(:courts)}

    before(:each) do
      create_settings_constant
    end

    subject               { BookingSlots::Activities.new(properties) }

    it { expect(subject.events.count).to eq(1) }
    it { expect(subject.closures.count).to eq(1) }

    describe '#current_record' do

      before(:each) do
        todays_slots.stub(:current).and_return(Slots::Slot.new("17:40","18:20"))
      end

      context 'nil' do
        it { expect(subject.current_record(todays_courts, todays_slots)).to be_nil }
      end

      context 'event' do
        let!(:event)    { create(:event, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "17:40", time_to: "18:20") }
        subject           { BookingSlots::Activities.new(properties) }

        it { expect(subject.current_record(todays_courts, todays_slots)).to eq(event) }
      end

      context 'closure' do
        let!(:closure)    { create(:closure, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "17:40", time_to: "18:20") }
        subject           { BookingSlots::Activities.new(properties) }

        it { expect(subject.current_record(todays_courts, todays_slots)).to eq(closure) }
      end
    end

end