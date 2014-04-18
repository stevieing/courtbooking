require 'spec_helper'

describe User::Admin do

  it_behaves_like "an STI class" do
    subject { build(:admin)}
  end

end