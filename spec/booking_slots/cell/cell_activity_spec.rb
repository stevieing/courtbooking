require 'spec_helper'

module BookingSlots::Cell
  describe "Cell" do

    before(:each) do
      create_settings_constant
      allow(Settings).to receive(:slots).and_return(build(:court_slots))
    end

    let!(:courts)             { create_list(:court_with_defined_opening_and_peak_times, 4)}
    let(:closure) { build(:closure)}
    let(:event)   { build(:event)}
    let(:user)    { build(:member)}

    describe "closure" do

      let(:closure) { build(:closure)}

      subject { BookingSlots::Cell::Activity.new(closure, user)}

      it { expect(subject).to_not be_a_link }
      it { expect(subject).to have_text(closure.description)}
      it { expect(subject).to have_a_span_of(closure.slot.between)}
      it { expect(subject).to be_active }
      it { expect(subject).to have_klass("closure")}
    end

    describe "event" do

      let(:event) { build(:event)}

      subject { BookingSlots::Cell::Activity.new(event, user)}

      it { expect(subject).to_not be_a_link }
      it { expect(subject).to have_text(event.description)}
      it { expect(subject).to have_a_span_of(event.slot.between)}
      it { expect(subject).to be_active }
      it { expect(subject).to have_klass("event")}
    end

     describe '#build' do

       let(:booking_slots_table) { build(:booking_slots_table)}

      it { expect(BookingSlots::Cell::Activity.build(closure, booking_slots_table)).to be_instance_of(BookingSlots::Cell::Activity)}

    end

  end
end