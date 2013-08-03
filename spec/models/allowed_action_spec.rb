require 'spec_helper'

describe AllowedAction do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:controller) }  
  it { should validate_presence_of(:action)}
  it {should have_db_column(:user_specific).of_type(:boolean).with_options(default: false)}
  
end
