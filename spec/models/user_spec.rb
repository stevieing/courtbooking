require 'spec_helper'

describe User do
  
  it "should not be able to register new users" do
    User.devise_modules.should_not include(:registerable)
  end
  
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  
  it {should have_db_column(:admin).of_type(:boolean).with_options(default: false)}
  
  context "without_user" do
    
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user, email: "user2@example.com") }
    let!(:user3) { create(:user, email: "user3@example.com") }
    subject { User.without_user(user1) }

    it {should_not include(user1)}
    it {should have(2).items}

  end

end
