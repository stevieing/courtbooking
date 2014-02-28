require "spec_helper"

describe BookingSlots::Cell do
		describe "with no arguments" do
			subject { BookingSlots::Cell.new }

			its(:text) 		{ should eq("&nbsp;")}
			its(:klass)		{ nil }
			its(:link)		{ nil }
			its(:link?)		{ should be_false }
			its(:span)		{ should eq(1) }
			it { should be_valid }
		  
		end

		describe "with arguments" do
			subject { BookingSlots::Cell.new("some text", "/link_to/cell/1", 5, "class") }

			its(:text) 			{ should eq("some text")}
			its(:klass)	    { should eq("class")}
			its(:link)			{ should eq("/link_to/cell/1") }
			its(:link?)			{ should be_true }
			its(:span)		{ should eq(5) }
			it { should be_valid }
		end

		describe '#add' do
			subject { BookingSlots::Cell.new }

			before(:each) do
				subject.add do |cell|
					cell.text 		= "some text"
					cell.klass 		= "class"
					cell.link 		= "/link_to/cell/1"
					cell.span 		= 5
				end
			end

			its(:text) 			{ should eq("some text")}
			its(:klass)	    { should eq("class")}
			its(:link)			{ should eq("/link_to/cell/1") }
			its(:link?)			{ should be_true }
			its(:span)		{ should eq(5) }
			it { should be_valid }
		end

end