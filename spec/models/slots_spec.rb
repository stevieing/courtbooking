require "spec_helper"

describe Slots do

	it { expect(described_class).to include(Enumerable)}

	let(:all_slots) 		{ ["06:20", "07:00", "07:40", "08:20", "09:00"] }
	let(:closing_time)	{ "09:40" }
	let(:slot_time)			{ 40 }
	let(:options)				{ {:courts_opening_time => all_slots.first.to_time, :courts_closing_time => all_slots.last.to_time, :slot_time => slot_time}}
	subject  						{ Slots.new(options)}

	its(:slots)  { should have(all_slots.count).items }
	its(:slots)  { should eq(all_slots) }
	its(:all)		 { should eq(all_slots) }
	its(:last)   { should eq(all_slots.last)}
	its(:first)  { should eq(all_slots.first)}
	its(:empty?) { should be_false}

	it { expect(subject.all? {|slot| all_slots.include? slot}).to be_true }

	describe "movement" do
		let(:skip) {3}

		its(:current) {should eq(all_slots.first)}
		its(:next) {should eq(all_slots[1])}

		it { expect{subject.skip(skip)}.to change{subject.current}.from(all_slots.first).to(all_slots[skip])}
		it { expect(subject.next(all_slots[1])).to eq(all_slots[2])}
		it { expect(subject.next(all_slots[4])).to eq(closing_time)}

		context "backwards" do
			before(:each) do
				subject.skip(skip)
			end

			it {expect{subject.previous}.to change{subject.current}.from(all_slots[skip]).to(all_slots[skip-1])}
			it {expect{subject.reset!}.to change{subject.current}.from(all_slots[skip]).to(all_slots.first)}
		end
	  
	end

	describe "manipulation" do
		let(:range) 			{["07:00", "08:20"]}
		let(:collection) 	{["07:00","07:40","08:20"]}
		let(:rejection) 	{["06:20", "09:00"]}

		it { expect(subject.collect_range(range.first, range.last)).to eq(collection)}
		it { expect(subject.reject_range(range.first, range.last)).to eq(rejection)}
		it { expect{subject.reject_range!(range.first, range.last)}.to change{subject.all}.from(all_slots).to(rejection)}
	end

  
end