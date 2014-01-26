require 'spec_helper'

describe Court do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end

  it { should have_many(:opening_times)}
  it { should have_many(:peak_times)}
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number) }
  
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
  
  describe "next court number" do
    
    context "with no records" do
      
      it {Court.next_court_number.should == 1}
    end
    
    context "with 3 records" do
      
      let!(:courts) { create_list(:court, 3)}
      
      it {Court.next_court_number == Court.maximum(:number)+1}
    end
  end
  
  describe "association add ons" do
    
    let!(:court) { create(:court) }
    let(:attributes) { {"0" => {"day"=>"0", "time_from"=>"06:20", "time_to"=>"22:20"},"1"=> {"day"=>"1", "time_from"=>"06:20", "time_to"=>"22:20"},"2" => {"day"=>"2", "time_from"=>"06:20", "time_to"=>"22:20"},"3" => {"day"=>"3", "time_from"=>"06:20", "time_to"=>"22:20"}}}
    let(:attributes_update) { {"0" => {"day"=>"0", "time_from"=>"06:20", "time_to"=>"21:40"},"1"=> {"day"=>"1", "time_from"=>"06:20", "time_to"=>"22:20"},"2" => {"day"=>"2", "time_from"=>"06:20", "time_to"=>"22:20"},"3" => {"day"=>"4", "time_from"=>"06:20", "time_to"=>"22:20"}, "4" => {"day"=>"5", "time_from"=>"06:20", "time_to"=>"22:20"}}}
    
    describe "should be included" do
      
      it { court.respond_to?(:build_opening_times).should be_true }
      it { court.respond_to?(:save_opening_times).should be_true }
      it { court.respond_to?(:build_peak_times).should be_true }
      it { court.respond_to?(:save_peak_times).should be_true }
      it { court.respond_to?(:update_opening_times).should be_true }
      it { court.respond_to?(:update_peak_times).should be_true }
      
    end
    
    describe "should work" do
      before(:each) do
        court.build_opening_times(attributes)
      end
    
      context "build" do
        it { court.opening_times.each {|o| o.new_record?.should be_true}}
      end
    
      context "save" do
        before(:each) do
          court.save_opening_times
        end
      
        it { court.opening_times.count.should == attributes.length}
        it { court.opening_times.each {|o| o.new_record?.should be_false}}
      
      end

      context "update" do
        before(:each) do
          court.save_opening_times
          court.update_opening_times(attributes_update)
          court.save_opening_times
        end

        it { court.opening_times.count.should == attributes_update.length}
        it { court.opening_times.find_by(day: 0).time_to.should == attributes_update["0"]["time_to"]}
        it { court.opening_times.find_by(day: 3).should be_nil}
      end
    end
  end

end


