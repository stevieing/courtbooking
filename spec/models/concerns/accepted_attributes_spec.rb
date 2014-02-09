require "spec_helper"

describe AcceptedAttributes do
  
  it { should respond_to :models}
  it { should respond_to :nested}

  let(:accepted_attributes) 					            { [:model_a, :attribute_a, :attribute_b, :attribute_c] }
  let(:nested_accepted_attributes)		            { [:model_a, :association_a, :attribute_a, :attribute_b, :attribute_c]}
  let(:accepted_attributes_with_a_hash)           { [:model_a, :attribute_a, :attribute_b, :attribute_c => []] }

  describe "setup" do
  	before(:each) do
  		AcceptedAttributes.setup do |config|
  			config.add *accepted_attributes
  			config.add_nested *nested_accepted_attributes
  		end
  	end

    context "attributes" do
      it { expect(described_class.models).to have(1).item}
      it { expect(described_class.models.first.name).to eq(accepted_attributes.first)}
      it { expect(described_class.models.first.attributes).to eq(accepted_attributes.dup.pop(3))}
      it { described_class.should respond_to accepted_attributes.first}
    end

    context "nested attributes" do
      it { expect(described_class.nested).to have(1).item }
      it { expect(described_class.nested.first.name).to eq(nested_accepted_attributes.first)}
      it { expect(described_class.nested.first.attributes).to eq(nested_accepted_attributes.dup.pop(3))}
      it { expect(described_class.nested.first.association).to eq(nested_accepted_attributes.at(1))}
    end

  end

  describe "attributes has a hash" do
    before(:each) do
      AcceptedAttributes.setup do |config|
        config.add *accepted_attributes_with_a_hash
      end

      it { expect(described_class.models).to have(1).item }
      it { described_class.should respond_to accepted_attributes_with_a_hash.first}
    end
  end
end