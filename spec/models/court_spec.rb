require 'spec_helper'

describe Court do

  it { should have_many(:opening_times)}
  it { should have_many(:peak_times)}
  it { should have_many(:closures).through(:occurrences)}
  it { should have_many(:events).through(:occurrences)}
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number) }
  
  describe "peak_times" do
    
    let!(:courts) { create_list(:court_with_opening_and_peak_times, 4)}
    
    it { courts.first.peak_time?(1,"09:40").should be_false}
    it { courts.first.peak_time?(1,"19:00").should be_true}
    it { courts.first.peak_time?(2,"19:00").should be_true}
    it { Court.peak_time?(courts.first.number, 1,"19:00").should be_true}
    it { Court.peak_time?(courts.first.number, 1,"09:40").should be_false}
  end
  
  describe "next court number" do

    it { expect(Court.next_court_number).to eq(1)}
  
    context "with multiple records" do
      
      let!(:courts) { create_list(:court,3)}

      it {expect(Court.next_court_number).to eq(Court.last.number+1)}
    end
  end

  describe "closures" do

    context "for all courts" do

      let(:date)      { Date.today}
      let!(:closure) { create(:closure, date_from: date, court_ids: Court.pluck(:id))}

      it { expect(Court.closures_for_all_courts(date)).to include(closure)}

    end
    
  end

end