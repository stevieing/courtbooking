require 'spec_helper'

shared_examples "an STI class" do

  it "should have attribute type" do
    expect(subject).to have_attribute :type
  end

  it "should initialize successfully as an instance of the described class" do
    expect(subject).to be_a_kind_of described_class
  end

end

shared_examples "time formats" do |*attributes|

	attributes.each do |attribute|

		it { should_not allow_value("1045").for(attribute) }
  	it { should_not allow_value("invalid playing from").for(attribute) }
  	it { should_not allow_value("25:45").for(attribute) }
  	it { should_not allow_value("10:63").for(attribute) }

	end
	
end

shared_examples "AppSettings" do
  it "should include AppSettings::ModelTrigger" do
    expect(described_class).to include(AppSettings::ModelTrigger)
  end

  it "should have the reload_constants method" do
    described_class.new.should respond_to(:reload_constants)
  end

  describe "methods" do
    before(:each) do
      setup_appsettings "#{described_class}s", "#{described_class}"
      FactoryGirl.create(described_class.to_s.downcase.to_sym, name: "my_name", value: "my_value")
    end

    it "should be added" do
      "#{described_class}s".constantize.should respond_to(:my_name)
    end

    it "should return the correct value" do
      expect("#{described_class}s".constantize.my_name).to eq("my_value")
    end
  end
end