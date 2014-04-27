require 'spec_helper'

module BookingSlots::Cell

  describe "Cell" do
    describe Booking do

      before(:each) do
        stub_settings
      end

      let!(:user)         { create(:member)}
      let!(:booking)      { create(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:30")}
      let!(:new_booking)  { build(:booking, date_from: Date.today+2, time_from: "19:00", time_to: "19:30")}

      describe 'new' do

        context 'in the future' do
          subject { BookingSlots::Cell::Booking.new(new_booking, user)}

          it { expect(subject).to have_text(new_booking.link_text)}
          it { expect(subject).to be_a_link}
          it { expect(subject).to be_a_link_to(court_booking_path(new_booking.new_attributes))}
          it { expect(subject).to have_klass("free")}
          it { expect(subject).to be_active}
          it { expect(subject).to have_a_span_of(1)}
        end

        context 'in the past' do

          before(:each) do
            stub_dates(Date.today+2, "20:00")
          end

          subject { BookingSlots::Cell::Booking.new(new_booking, user)}

          it { expect(subject).to have_text(new_booking.players)}
          it { expect(subject).to_not be_a_link}
          it { expect(subject).to have_klass("free")}
        end


      end

      describe "persistent" do
        context 'in the past' do

          before(:each) do
            stub_dates(Date.today+2, "20:00")
          end

          subject { BookingSlots::Cell::Booking.new(booking, user)}

          it { expect(subject).to have_text(booking.players)}
          it { expect(subject).to_not be_a_link}
          it { expect(subject).to have_klass("booking")}
        end

        context 'in the future' do

          subject { BookingSlots::Cell::Booking.new(booking, user)}

          context 'editable' do

            before(:each) do
              allow(user).to receive(:allow?).with(:bookings, :edit, booking).and_return(true)
            end

            it { expect(subject).to have_text(booking.players)}
            it { expect(subject).to be_a_link}
            it { expect(subject).to be_a_link_to(edit_booking_path(booking))}
            it { expect(subject).to have_klass("booking")}

          end

        end

      end

      describe '#build' do

        it { expect(BookingSlots::Cell::Booking.build(booking, user)).to be_instance_of(BookingSlots::Cell::Booking)}

      end

    end
  end
end