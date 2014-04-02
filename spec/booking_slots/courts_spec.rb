require 'spec_helper'

describe BookingSlots::Courts do

  let!(:courts)       { create_list(:court_with_opening_and_peak_times, 4) }
  let(:properties)    { build(:properties)}
  subject             { BookingSlots::Courts.new(properties) }

  it_behaves_like IndexManager do
    let(:enum_attribute)  { :@courts }
  end

  it { should be_valid}
  it { expect(subject.all.count).to eq(4)}

  describe '#header' do
    it { expect(subject.header).to have(6).items }
    it { expect(subject.header.first).to eq("&nbsp;") }
    it { expect(subject.header.last).to eq("&nbsp;") }
    it { expect(courts.any? { |court| subject.header.each { |cell| cell == "Court #{court.number}" } } ).to be_true}
  end

  describe '#current_open?' do

    let!(:courts)       { create_list(:court_with_defined_opening_and_peak_times, 4, opening_time_from: "08:00", opening_time_to: "12:00") }
    subject             { BookingSlots::Courts.new(properties) }

    it { expect(subject.current_open?("07:00")).to be_false }
    it { expect(subject.current_open?("10:00")).to be_true  }
    it { expect(subject.current_open?("13:00")).to be_false }

  end

end