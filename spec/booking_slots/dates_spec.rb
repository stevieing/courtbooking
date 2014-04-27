require 'spec_helper'

describe BookingSlots::Dates do

  let(:date_from) { Date.parse("10 March 2014")}


  before(:each) do
    Date.stub(:today).and_return(Date.parse("14 March 2014"))
  end

  let(:attributes) { { date_from: date_from, current_date: Date.today, no_of_days: 20} }

  subject { BookingSlots::Dates.new(attributes)}

  it_behaves_like IndexManager do
    let(:enum_attribute) { :@dates }
  end

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

    it { expect(subject.current_record).to eq(subject.first)}

  end

  describe '#current_date' do

    it { expect(subject.current_date).to eq(Date.today)}

  end

end