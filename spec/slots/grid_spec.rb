require "spec_helper"

describe Slots::Grid do

	let(:court_slots)	{ build(:court_slots)}
	
	subject 					{ Slots::Grid.new(4, court_slots) }

	its(:count)				{ should eq(4) }

	it { should be_valid }

	it { expect(subject.all? {|o| o.instance_of? (court_slots.class)}).to be_true }
	it { expect(subject.any? {|o| o === court_slots} ).to be_false }

	it { expect(subject[0].current).to eq(court_slots.current) }
	it { expect{court_slots.up}.to_not change{subject[0].current} }
	it { expect{subject[0].up}.to_not change{court_slots.current} }

	describe '#synced?' do

		it { expect(subject.synced?(0)).to be_true }
		it { expect{subject[0].up(3)}.to change{subject.synced?(0)}.from(true).to(false) }
	end

	describe '#skip' do

		it { expect{subject.skip(0,4)}.to change{subject.objects[0].index}.from(0).to(4)}
		it { expect{subject.skip(3,2)}.to change{subject.objects[3].index}.from(0).to(2)}
		it { expect{subject.skip(1,1)}.to change{subject.objects[1].index}.from(0).to(1)}
	end

end