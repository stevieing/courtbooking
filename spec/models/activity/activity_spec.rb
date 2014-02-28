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

  describe "by day" do

    let!(:closures_in)  { create_list(:closure, 3, date_from: Date.today, date_to: Date.today+5) }
    let!(:closures_out) { create_list(:closure, 2, date_from: Date.today+6, date_to: Date.today+8) }
    let!(:events_in)  { create_list(:event,3, date_from: Date.today) }
    let!(:events_out) { create_list(:event,2, date_from: Date.today+1) } 
    
    it { expect(Closure.by_day(Date.today).count).to eq(closures_in.count)}
    it { expect(Closure.by_day(Date.today+5).count).to eq(closures_in.count)}
    it { expect(Closure.by_day(Date.today+2).count).to eq(closures_in.count)}
    it { expect(Event.by_day(Date.today).count).to eq(events_in.count) }
      
  end

end
