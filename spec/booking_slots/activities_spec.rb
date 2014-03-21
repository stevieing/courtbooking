require 'spec_helper'

describe BookingSlots::Activities do

    let!(:courts)         { create_list(:court, 4)}
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

    describe '#current_activity' do

      before(:each) do
        todays_slots.stub(:current).and_return(Slots::Slot.new("17:40","18:20"))
      end

      context 'nil' do
        it { expect(subject.current_activity(todays_courts, todays_slots)).to be_nil }
      end

      context 'event' do
        let!(:event)    { create(:event, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "17:40", time_to: "18:20") }
        subject           { BookingSlots::Activities.new(properties) }

        it { expect(subject.current_activity(todays_courts, todays_slots)).to eq(event) }
      end

      context 'closure' do
        let!(:closure)    { create(:closure, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "17:40", time_to: "18:20") }
        subject           { BookingSlots::Activities.new(properties) }

        it { expect(subject.current_activity(todays_courts, todays_slots)).to eq(closure) }
      end
    end

    describe '#current_record' do

      before(:each) do
        allow(Settings).to receive(:slots).and_return(CourtSlots.new(options))
      end

      context 'event' do
        let!(:event)      { create(:event, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "14:00", time_to: "16:00") }
        let(:activities)  { BookingSlots::Activities.new(properties) }
        subject           { activities.current_record(todays_courts, todays_slots)}

        before(:each) do
          allow_any_instance_of(BookingSlots::Activities).to receive(:get_activity).and_return(event)
        end

        it { expect(subject).to be_instance_of(BookingSlots::CurrentRecord) }
        it { expect(subject.text).to eq(event.description) }
        it { expect(subject.span).to eq(event.slot.between) }
        it { expect(subject.klass).to eq("event") }

      end

      context 'closure' do
        let!(:closure)    { create(:closure, court_ids: Court.pluck(:id), date_from: date+1, date_to: date+1, time_from: "14:00", time_to: "16:00") }
        let(:activities)  { BookingSlots::Activities.new(properties) }
        subject           { activities.current_record(todays_courts, todays_slots)}

        before(:each) do
          allow_any_instance_of(BookingSlots::Activities).to receive(:get_activity).and_return(closure)
        end

        it { expect(subject).to be_instance_of(BookingSlots::CurrentRecord)}
        it { expect(subject.text).to eq(closure.description)}
        it { expect(subject.span).to eq(closure.slot.between)}
        it { expect(subject.klass).to eq("closure") }

      end

      context 'nil' do
        let(:activities)  { BookingSlots::Activities.new(properties) }
        subject           { activities.current_record(todays_courts, todays_slots)}

        before(:each) do
          allow_any_instance_of(BookingSlots::Activities).to receive(:get_activity).and_return(nil)
        end

        it { expect(subject).to be_nil}

      end




    end


end