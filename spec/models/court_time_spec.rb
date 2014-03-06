require 'spec_helper'

describe CourtTime do
  
  it { should validate_presence_of(:time_from)}
  it { should validate_presence_of(:time_to)}
  it { should validate_presence_of(:day)}
  it { should belong_to(:court)}

  it_behaves_like "time formats", :time_from, :time_to
  
  describe CourtTime::OpeningTime do
    it_behaves_like "an STI class"

    describe '#open?' do
      subject { create(:court_with_defined_opening_and_peak_times, opening_time_from: "08:00", opening_time_to: "12:00" )}

      it { expect(subject.open?(0, "07:00")).to be_false }
      it { expect(subject.open?(0, "07:59")).to be_false }
      it { expect(subject.open?(0, "08:00")).to be_true }
      it { expect(subject.open?(0, "08:01")).to be_true }
      it { expect(subject.open?(0, "10:00")).to be_true }
      it { expect(subject.open?(0, "11:59")).to be_true }
      it { expect(subject.open?(0, "12:00")).to be_true }
      it { expect(subject.open?(0, "12:01")).to be_false }
      it { expect(subject.open?(0, "13:00")).to be_false }
      it { expect(subject.open?(5, "07:00")).to be_false }
      it { expect(subject.open?(5, "10:00")).to be_true }

    end
  end
  
  describe CourtTime::PeakTime do
    it_behaves_like "an STI class"
  end

  describe "Time to after time from" do
    subject { build(:court_time, day: 0, time_from: "22:20", time_to: "21:40")}

    it { should_not be_valid}
  end

end