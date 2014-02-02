require 'spec_helper'

describe Activity do
  it {should validate_presence_of(:date_from)}
  it {should validate_presence_of(:time_from)}
  it {should validate_presence_of(:time_to)}
  it {should validate_presence_of(:description)}
  it {should have_many(:courts).through(:occurrences)}
  it {should validate_presence_of(:courts)}

  it_behaves_like "time formats", :time_from, :time_to

  describe "Time to after time from" do
    subject { build(:activity, time_from: "22:20", time_to: "21:40")}

    it { should_not be_valid}
  end

  describe Closure::Activity do
    it_behaves_like "an STI class"
  end

end
