require 'spec_helper'

describe BookingSlots::Dates do

  let(:date_from) { Date.parse("10 March 2014")}

  before(:each) do
    Date.stub(:today).and_return(Date.parse("14 March 2014"))
  end

  subject { BookingSlots::Dates.new(date_from, Date.today, 20)}
  let(:enum_attribute) { :@dates }

  it_behaves_like IndexManager

  describe '#dates' do

    it { expect(subject.dates).to have(20).items}
    it { expect(subject.dates.first).to be_instance_of(Date)}
    it { expect(subject.dates.first).to eq(date_from)}
    it { expect(subject.dates.last).to eq(date_from+19)}
  end

  describe '#header' do

    it { expect(subject.header.count).to eq(7)}
    it { expect(subject.header.first).to eq(date_from.strftime('%a'))}
    it { expect(subject.header.last).to eq((date_from+6).strftime('%a'))}
  end

  describe '#current record' do

    it { expect(subject.current_record).to have_text(subject.first.day_of_month)}
    it { expect(subject.current_record).to be_a_link_to(courts_path(subject.first.to_s))}

    context 'today' do

      before(:each) do
        subject.up(4)
      end

      it { expect(subject.current_record).to have_text(Date.today.day_of_month)}
      it { expect(subject.current_record.link).to be_nil }
      it { expect(subject.current_record.klass).to eq("current")}
    end

  end

end