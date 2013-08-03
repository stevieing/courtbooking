require 'spec_helper'

describe Permission do
  
  it { should belong_to(:user)}
  it { should belong_to(:allowed_action)}
  
end
