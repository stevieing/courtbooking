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
