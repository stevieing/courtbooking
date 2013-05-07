require 'spec_helper'

describe User do
  
  it "should not be able to register new users" do
    User.devise_modules.should_not include(:registerable)
  end
  
  describe "valid user" do
    
    subject {create(:user)}
    it {should be_valid}
    
    its(:username) {should_not be_blank}
    its(:password) {should_not be_blank}
    its(:email) {should_not be_blank}
    its(:admin) {should_not be_nil}
    its(:admin) {should be_false}
 
  end
  
  describe "valid admin" do
    
    subject {create(:user, admin: true)}
    it {should be_valid}
    its(:admin) {should be_true}
    
  end
  
  describe "without_user" do
    
    before(:each) do
      @user1 = create(:user, username: "user1", password: "username1", email: "user1@example.com")
      @user2 = create(:user, username: "user2", password: "username2", email: "user2@example.com")
      @user3 = create(:user, username: "user3", password: "username3", email: "user3@example.com")
      @users = User.without_user(@user1)
    end
    
    it "should not contain the specified user" do
      @users.each {|user| user.id.should_not eql(@user1.id)}
    end
    
    it "should have the correct number of users" do
      @users.length.should == 2
    end
    
  end

end
