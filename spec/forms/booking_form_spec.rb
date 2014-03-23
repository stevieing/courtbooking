require 'spec_helper'

describe BookingForm do

  before(:each) do
    stub_settings
  end

  it_behaves_like FormManager

end