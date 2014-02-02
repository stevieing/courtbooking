require 'spec_helper'

describe CourtTime do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end
  
  it { should validate_presence_of(:time_from)}
  it { should validate_presence_of(:time_to)}
  it { should validate_presence_of(:day)}
  it { should belong_to(:court)}

  it_behaves_like "time formats", :time_from, :time_to
  
  describe CourtTime::OpeningTime do
    it_behaves_like "an STI class"
  end
  
  describe CourtTime::PeakTime do
    it_behaves_like "an STI class"
  end

  describe "Time to after time from" do
    subject { build(:court_time, day: 0, time_from: "22:20", time_to: "21:40")}

    it { should_not be_valid}
  end

end