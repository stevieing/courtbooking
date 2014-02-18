require "spec_helper"

describe Activity do

	describe Activity::Closure do

		subject {build(:closure)}

    it_behaves_like "an STI class"

		it {should validate_presence_of(:date_to)}

		describe "date to before date from" do

			subject {build(:closure, date_to: Date.today-1)}

			it { should_not be_valid }
		end

		describe "message" do
	  	subject { create(:closure)}

	  	its(:message) {should eq("Courts #{subject.court_ids.join(',')} closed from #{subject.time_from} to #{subject.time_to} for #{subject.description}")}
		end
	end
      
end