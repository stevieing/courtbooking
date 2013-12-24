require 'spec_helper'

describe Court do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end

  it { should validate_presence_of(:number)}
  it { should validate_uniqueness_of(:number)}
  it { should have_many(:opening_times)}
  it { should have_many(:peak_times)}
  
  describe "opening times" do
    
    let!(:courts) { create_list(:court_with_opening_and_peak_times, 4)}
    
    it { courts.first.open?(1,"06:00").should be_false}
    it { courts.first.open?(1,"10:20").should be_true}

  end
  
  describe "peak_times" do
    
    let!(:courts) { create_list(:court_with_opening_and_peak_times, 4)}
    
    it { courts.first.peak_time?(1,"09:40").should be_false}
    it { courts.first.peak_time?(1,"19:00").should be_true}
    it { courts.first.peak_time?(2,"19:00").should be_true}
    it { Court.peak_time?(courts.first.number, 1,"19:00").should be_true}
    it { Court.peak_time?(courts.first.number, 1,"09:40").should be_false}
  end
  
  describe "court number" do
    
    context "with no records" do
      
      it {Court.new.number.should == 1}
    end
    
    context "with 3 records" do
      
      let!(:courts) { create_list(:court, 3)}
      
      it {Court.new.number.should == Court.maximum(:number)+1}
    end
  end

end


