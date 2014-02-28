require 'spec_helper'

describe BookingSlots::Courts do
  
  let!(:courts)			{ create_list(:court, 4)}
	let(:properties) 	{ build(:properties)}

  subject { BookingSlots::Courts.new(properties)}

  it { should be_valid}
  it { expect(subject.all.count).to eq(4)}
  it { expect(subject.end?).to be_false}
  it { expect(subject.current).to eq(courts.first)}
  it { expect(subject.index).to eq(0)}
  it { expect{subject.up}.to change{subject.current}.from(courts.first).to(courts[1])}
  it { expect{subject.up(4)}.to change{subject.end?}.from(false).to(true)}
end