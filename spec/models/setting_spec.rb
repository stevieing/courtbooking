require 'spec_helper'

describe Setting do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:description) }
  
  it { should_not allow_value("my name").for(:name) }
  it { should_not allow_value("$my_name").for(:name) }
  it { should_not allow_value("#my_name").for(:name) }
  
  it { should validate_uniqueness_of(:name) }
  
  describe Setting::NumberSetting do

    subject { build(:number_setting)}
    
    it { should validate_numericality_of(:value) }
    it { should_not allow_value(-1).for(:value) }

    it_behaves_like "an STI class" 
    
  end
  
  describe Setting::TimeSetting do

    subject { build(:time_setting)}

    it_behaves_like "an STI class"
    it_behaves_like "time formats", :value
    
  end

  it_behaves_like "AppSettings"

end