require "spec_helper"

describe BookingSlots::Row do

  subject { BookingSlots::Row.new }

  it { expect(subject).to be_instance_of(BookingSlots::Row)}
  its(:heading?)  { should be_false }
  its(:cells)     { should be_empty }
  its(:klass)     { should be_nil}
  its(:count)     { should eq(0) }

  describe "klass" do

    subject { BookingSlots::Row.new(klass: "klass", heading: true) }

    its(:klass) { should eq("klass")}
    its(:heading?) { should be_true}

  end

end