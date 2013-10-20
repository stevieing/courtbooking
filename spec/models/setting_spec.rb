require 'spec_helper'

describe Setting do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:description) }
  
  it { should_not allow_value("my name").for(:name) }
  it { should_not allow_value("$my_name").for(:name) }
  it { should_not allow_value("#my_name").for(:name) }
  
  it { should validate_uniqueness_of(:name) }
  
  describe "configuration constants" do
    
    let!(:setting) {create(:setting, name: "my_setting", value: "my value")}
    it {setting.value.should eq(Rails.configuration.my_setting)}
    
    describe "should be the correct format" do
      
      context "numeric" do
        let!(:setting) {create(:setting, name: "my_setting", value: "21")}
        it {Rails.configuration.my_setting.should be_instance_of(Fixnum)}
      end
      
      context "time" do
        let!(:setting) {create(:setting, name: "my_setting", value: "23:59")}
        it {Rails.configuration.my_setting.should be_instance_of(Time)}
      end
      
    end
    
  end
  
  describe NumberSetting do
    
    it {should validate_numericality_of(:value)}
    it { should_not allow_value(-1).for(:value) }
    
    subject { create(:number_setting) }
    its(:type) {should eq("NumberSetting")}
  end
  
  describe TimeSetting do
    
    it { should_not allow_value("1045").for(:value) }
    it { should_not allow_value("invalid value").for(:value) }
    it { should_not allow_value("25:45").for(:value) }
    it { should_not allow_value("10:63").for(:value) }
    
    subject { create(:time_setting)}
    its(:type) {should eq("TimeSetting")}
  end
  
  describe "by name" do
    
    let!(:setting) {create(:setting, name: "my_setting", value: "my value")}
    it {Setting.by_name("my_setting").should eq("my value")}
  end
  
  describe "Slots" do
    
    before(:each) do
      create(:slot_time)
      create(:courts_opening_time)
      create(:courts_closing_time)
    end
    
    it {Rails.configuration.slots.should_not be_nil}
  end

end