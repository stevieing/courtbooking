require "spec_helper"

describe BookingSlots::Row do

  subject { BookingSlots::Row.new }

  it { expect(subject).to be_instance_of(BookingSlots::Row)}
  its(:heading?)  { should be_false }
  its(:cells)     { should be_empty }
  its(:klass)     { should be_nil}
  its(:count)     { should eq(0) }

  describe "klass" do

    subject { BookingSlots::Row.new([],"klass") }

    its(:klass) { should eq("klass")}

  end

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

end