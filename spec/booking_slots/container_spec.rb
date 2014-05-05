require 'spec_helper'

describe BookingSlots::Container do

  class TestContainer
    include BookingSlots::Container
  end

  describe '#new' do

    subject { TestContainer.new }

    its(:cells) { should be_empty }
    it          { should_not be_valid }
    it          { should respond_to(:wrap)}
    it          { should respond_to(:cap)}

  end

  describe '#add' do

    subject { TestContainer.new.add("some text") }

    it { expect(subject).to have(1).item }
    it { expect(subject.first).to eq("some text")}
    it { should be_valid }

  end

  describe "new with block" do

   subject { TestContainer.new do |container|
        container.add "text1"
      end
    }

    it { expect(subject).to have(1).item }
    it { expect(subject.first).to eq("text1") }

  end

end