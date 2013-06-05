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
    let!(:users) {create_list(:user, 3)}
    subject { User.without_user(users.first) }

    it {should_not include(users.first)}
    it {should have(2).items}

  end
  
  context "class username" do
    
    let!(:user) {create(:user, username: "joebloggs")}
    
    it { User.username(user.id).should == "joebloggs"}
  end
  

end
