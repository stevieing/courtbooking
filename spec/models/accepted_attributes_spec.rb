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

  	it { AcceptedAttributes.models.length.should == 1}
  	it { AcceptedAttributes.models.first.name.should == accepted_attributes.first}
  	it { AcceptedAttributes.models.first.attributes.should == accepted_attributes.dup.pop(3)}
  	it { AcceptedAttributes.should respond_to accepted_attributes.first}

  	it { AcceptedAttributes.nested.length.should == 1}
  	it { AcceptedAttributes.nested.first.name.should == nested_accepted_attributes.first}
  	it { AcceptedAttributes.nested.first.attributes.should == nested_accepted_attributes.dup.pop(3)}
  	it { AcceptedAttributes.nested.first.association.should == nested_accepted_attributes.at(1)}

  end

  describe "attributes has a hash" do
    before(:each) do
      AcceptedAttributes.setup do |config|
        config.add *accepted_attributes_with_a_hash
      end

      it { AcceptedAttributes.models.length.should == 1}
      it { AcceptedAttributes.should respond_to accepted_attributes_with_a_hash.first}
    end
  end


end