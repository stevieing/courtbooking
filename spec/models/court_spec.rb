require 'spec_helper'

describe Court do
  
  describe "valid court" do

    subject {create(:court)}
    it {should be_valid}

    its(:number) {should_not be_blank}
  end
  
end


