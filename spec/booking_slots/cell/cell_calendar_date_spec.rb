require 'spec_helper'

module BookingSlots::Cell
  describe "Cell" do

    let(:date)          { Date.today}
    let(:current_date)  { Date.today+2}

    describe 'any old date' do

      subject { CalendarDate.new(date, current_date)}

      it { expect(subject.text).to eq(date.day_of_month)}
      it { expect(subject).to be_a_link_to(courts_path(date.to_s))}
      it { expect(subject).to have_klass(nil)}
    end

    describe "current date" do

      subject { CalendarDate.new(current_date, current_date)}

      it { expect(subject.text).to eq(current_date.day_of_month)}
      it { expect(subject).to_not be_a_link }
      it { expect(subject).to have_klass("selected")}

    end
  end

end