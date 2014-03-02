require "spec_helper"

describe BookingSlots::Cell do
		describe "with no arguments" do
			subject { BookingSlots::Cell.new }

			its(:text) 		{ should eq("&nbsp;")}
			its(:klass)		{ nil }
			its(:link)		{ nil }
			its(:link?)		{ should be_false }
			its(:span)		{ should eq(1) }
			it 						{ should be_valid }
		  
		end

		describe "with arguments" do
			subject { BookingSlots::Cell.new("some text", "/link_to/cell/1", 5, "class") }

			its(:text) 		{ should eq("some text")}
			its(:klass)	  { should eq("class")}
			its(:link)		{ should eq("/link_to/cell/1") }
			its(:link?)		{ should be_true }
			its(:span)		{ should eq(5) }
			it 						{ should be_valid }
		end

		describe '#add' do

			let(:cell)		{ BookingSlots::Cell.new }
			let(:record) 		{ BookingSlots::CurrentRecord.new do |record|
					record.text 		= "some text"
					record.klass 		= "class"
					record.link 		= "/link_to/cell/1"
					record.span 		= 5
				end }

			before(:each) do
				cell.add(record)
			end

			it { expect(cell.text).to eq("some text") }
			it { expect(cell.klass).to eq("class")}
			it { expect(cell.link).to	eq("/link_to/cell/1") }
			it { expect(cell.link?).to be_true }
			it { expect(cell.span).to eq(5) }
			it { expect(cell).to be_valid }

		end

end