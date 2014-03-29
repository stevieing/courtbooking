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

#TODO: improve way variables are passed.
shared_examples IndexManager do

  it { expect(described_class).to include(IndexManager) }
  it { expect(described_class).to include(Enumerable) }
  it { expect(subject.index).to eq(0) }
  it { expect(subject.enumerator).to eq(subject.instance_variable_get(enum_attribute))}
  it { expect(subject).to respond_to(:each)}
  it { expect(subject.current).to eq(subject.instance_variable_get(enum_attribute).first)}

end

shared_examples FormManager do
  it { expect(described_class).to include(FormManager) }
  it { expect(described_class).to include(ActiveModel::Model) }
  it { expect(described_class).to include(ParametersProcessor) }

  it { expect(described_class).to respond_to(:set_model)}
  it { expect(described_class).to respond_to(:add_initializer)}
  it { expect(described_class).to respond_to(:set_associated_models)}

end

shared_examples "password processed" do
  let(:attributes)  { attributes_for(model).merge(password: "", password_confirmation: "")}
  subject           { described_class.new(create(model))}

   before(:each) do
    subject.submit(attributes)
   end

  it { expect(model.to_s.classify.constantize.all).to have(1).item }
  it { expect(subject).to be_valid }
end

shared_examples OverlappingRecordsManager do

  it { expect(described_class).to include(OverlappingRecordsManager)}
  it { expect(described_class).to respond_to(:overlapping_object)}

end

shared_examples "Removes overlapping records" do

  subject { described_class.new}

  before(:each) do
    stub_settings
  end

  let!(:booking)    { create(:booking) }
  let!(:closure)    { create(:closure) }
  let!(:event)      { create(:event) }

  before(:each) do
    allow_any_instance_of(OverlappingRecords).to receive(:get_records).and_return(Booking.all+Activity.all)
    subject.submit(attributes.merge(allow_removal: true))
  end

  it { expect(Booking.all).to be_empty }
  it { expect(Activity.all).to_not include(closure) }
  it { expect(Activity.all).to_not include(event) }

end

shared_examples "Verifies removal of overlapping records" do

  subject { described_class.new}

  let!(:closure)    { create(:closure) }
  let!(:event)      { create(:event) }

  before(:each) do
    allow_any_instance_of(OverlappingRecords).to receive(:get_records).and_return(Booking.all+Activity.all)
    subject.submit(attributes.merge(allow_removal: false))
  end

  it { expect(subject).to_not be_valid }
  it { expect(Activity.all).to include(closure) }
  it { expect(Activity.all).to include(event) }

end
