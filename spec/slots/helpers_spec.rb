require "spec_helper"

describe Slots::Helpers do

  class TestClass
    include Slots::Helpers
  end

  subject { TestClass.new }

  describe '#to_time' do

    it { expect(subject.to_time(10)).to eq(10)}
    it { expect(subject.to_time("10:30")).to be_instance_of(Time)}
    it { expect(subject.to_time(Time.parse("10:30"))).to be_instance_of(Time)}
    it { expect(subject.to_time(nil)).to be_nil}
  end

  describe '#to_range' do

    it { expect(subject.to_range("06:00","08:00",30)).to eq(["06:00","06:30","07:00","07:30","08:00"])}

  end

end