require 'spec_helper'

describe User::Member do

  it_behaves_like "an STI class" do
    subject { build(:member)}
  end
end