require 'spec_helper'

describe User::Admin do

  subject { build(:admin)}

  it_behaves_like "an STI class"

  its(:admin?) { should be_true}

end