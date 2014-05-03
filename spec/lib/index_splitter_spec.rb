require 'spec_helper'

describe IndexSplitter do

  class TestSplitter

    attr_reader :args, :split

    include IndexSplitter
    set_enumerator_with_split :args, :split

    def initialize(args, split)
      @args, @split = args, split
    end
  end

  subject { TestSplitter.new([1,2,3,4,5,6,7,8,9,10], 5)}

  it { expect(subject.enumerator).to eq(subject.args) }
  it { expect(subject.splitter).to eq(5)}
   it { expect(subject.split).to eq(5)}
  it { expect{subject.up(5)}.to change{subject.split?}.from(false).to(true)}
  it { expect{subject.up(10)}.to change{subject.end?}.from(false).to(true)}

  describe "odd split" do
    subject { TestSplitter.new([1,2,3,4,5,6,7,8,9,10], 5)}

    it { expect{subject.up(5)}.to change{subject.split?}.from(false).to(true)}
    it { expect{subject.up(11)}.to change{subject.end?}.from(false).to(true)}
    it { expect{subject.up(11)}.to change{subject.split?}.from(false).to(true)}

  end

end