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

      it { expect(subject).to_not open_on(0, "07:00")}
      it { expect(subject).to_not open_on(0, "07:59")}
      it { expect(subject).to open_on(0, "08:00")}
      it { expect(subject).to open_on(0, "08:01")}
      it { expect(subject).to open_on(0, "10:00")}
      it { expect(subject).to open_on(0, "11:59")}
      it { expect(subject).to open_on(0, "12:00")}
      it { expect(subject).to_not open_on(0, "12:01")}
      it { expect(subject).to_not open_on(0, "13:00")}
      it { expect(subject).to_not open_on(5, "07:00")}
      it { expect(subject).to open_on(5, "10:00")}


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