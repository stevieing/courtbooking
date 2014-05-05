require "spec_helper"

module BookingSlots::Cell
  describe "Cell" do

    before(:each) do
      create_settings_constant
      allow(Settings).to receive(:slots).and_return(build(:court_slots))
    end

    let!(:courts)             { create_list(:court_with_defined_opening_and_peak_times, 4)}
    let(:booking_slots_table) { build(:booking_slots_table)}

    describe '#build' do

      context 'open' do

        context 'booking' do
          before(:each) do
            allow(booking_slots_table).to receive(:current_record).and_return(build(:booking, user: build(:member)))
          end

          subject { BookingSlots::Cell.build(:open, booking_slots_table) }

          it { expect(subject).to be_instance_of(BookingSlots::Cell::Booking) }
        end

        context 'activity' do
          before(:each) do
            allow(booking_slots_table).to receive(:current_record).and_return(build(:closure))
          end

          subject { BookingSlots::Cell.build(:open, booking_slots_table) }

          it { expect(subject).to be_instance_of(BookingSlots::Cell::Activity) }
        end

      end

      context 'blank' do
        subject { BookingSlots::Cell.build(:blank) }

        it { expect(subject).to be_instance_of(BookingSlots::Cell::Blank)}
      end

      context 'closed' do
        subject { BookingSlots::Cell.build(:closed) }

        it { expect(subject).to be_instance_of(BookingSlots::Cell::Closed)}
      end

      context 'BookingSlots::Table' do

        subject {build(:booking_slots_table)}

        context 'booking' do
          before(:each) do
            allow(subject).to receive(:current_record).and_return(build(:booking))
          end

          it { expect(BookingSlots::Cell.build(subject)).to be_instance_of(BookingSlots::Cell::Booking)}
        end

        context 'activity' do
          before(:each) do
            allow(subject).to receive(:current_record).and_return(build(:activity))
          end

          it { expect(BookingSlots::Cell.build(subject)).to be_instance_of(BookingSlots::Cell::Activity)}
        end
      end

      context 'Calendar' do

        it { expect(BookingSlots::Cell.build(Date.today, Date.today)).to be_instance_of(BookingSlots::Cell::CalendarDate)}
      end
    end


    describe Base do

      class TestCell
        include BookingSlots::Cell::Base
      end

      subject   { TestCell.new }

      its(:text)    { should be_nil }
      its(:klass)   { should be_nil }
      its(:link)    { should be_nil }
      its(:link?)   { should be_false }
      its(:span)    { should eq(1) }
      its(:blank?)  { should be_false }
      its(:active?) { should be_false }
      its(:closed?) { should be_false }
      it            { should be_valid }

      describe '#build' do
        it { expect(TestCell.build).to be_instance_of(TestCell)}
      end
    end

    describe Text do

      context "no text" do
        subject { BookingSlots::Cell::Text.new }

        its(:text)    { should eq("&nbsp;")}
        its(:klass)   { nil }
        its(:link)    { nil }
        its(:link?)   { should be_false }
        its(:span)    { should eq(1) }
        it            { should be_valid }
      end

    end

    describe Blank do
      subject { BookingSlots::Cell::Blank.new }

      its(:blank?)  { should be_true}

      describe '#build' do

        subject { BookingSlots::Cell::Blank.build(build(:booking)) }

        it { expect(subject).to be_instance_of(BookingSlots::Cell::Blank)}
        it { expect(subject).to have_text(nil)}
      end
    end

    describe Closed do
      subject { BookingSlots::Cell::Closed.new }

      its(:closed?) { should be_true}
      its(:klass)   { should eq("closed")}

      describe '#build' do

        subject { BookingSlots::Cell::Closed.build(build(:booking)) }

        it { expect(subject).to be_instance_of(BookingSlots::Cell::Closed)}
        it { expect(subject).to have_text(nil)}
      end
    end

  end
end