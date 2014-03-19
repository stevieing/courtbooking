require 'spec_helper'

describe BookingSlots::HtmlKlass do

  before(:each) do
    allow(DateTime).to receive(:now).and_return(DateTime.parse("17:00"))
  end

  let(:event)     { build(:event)   }
  let(:closure)   { build(:closure) }
  let(:booking)   { build(:booking) }

  describe "class" do

    it { expect(BookingSlots::HtmlKlass.new(event).value).to eq("event")}
    it { expect(BookingSlots::HtmlKlass.new(closure).value).to eq("closure")}
    it { expect(BookingSlots::HtmlKlass.new(booking).value).to eq("booking")}

  end

  describe "time" do

    it { expect(BookingSlots::HtmlKlass.new(DateTime.parse("16:00")).value).to eq("past")}
    it { expect(BookingSlots::HtmlKlass.new(DateTime.parse("16:59")).value).to eq("past")}
    it { expect(BookingSlots::HtmlKlass.new(DateTime.parse("17:00")).value).to eq("past")}
    it { expect(BookingSlots::HtmlKlass.new(DateTime.parse("17:01")).value).to eq(nil)}
    it { expect(BookingSlots::HtmlKlass.new(DateTime.parse("18:00")).value).to eq(nil)}

  end

end