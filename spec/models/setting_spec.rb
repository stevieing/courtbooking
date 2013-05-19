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

end