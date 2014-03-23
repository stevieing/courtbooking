require 'spec_helper'

describe BookingSlots::Courts do

  let!(:courts)       { create_list(:court, 4)}
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

end