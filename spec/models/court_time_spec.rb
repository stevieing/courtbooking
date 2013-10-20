require 'spec_helper'

describe CourtTime do
  
  before(:all) do
    create_standard_settings
  end
  
  after(:all) do
    Setting.delete_all
  end
  
  it { should validate_presence_of(:from)}
  it { should validate_presence_of(:to)}
  it { should validate_presence_of(:day)}
  it { should belong_to(:court)}
  
  it { should_not allow_value("1045").for(:from) }
  it { should_not allow_value("invalid value").for(:from) }
  it { should_not allow_value("25:45").for(:from) }
  it { should_not allow_value("10:63").for(:from) }
  
  it { should_not allow_value("1045").for(:to) }
  it { should_not allow_value("invalid value").for(:to) }
  it { should_not allow_value("25:45").for(:to) }
  it { should_not allow_value("10:63").for(:to) }
  
  describe CourtTime::OpeningTime do
    it_behaves_like "an STI class"
  end
  
  describe CourtTime::PeakTime do
    it_behaves_like "an STI class"
  end
end
