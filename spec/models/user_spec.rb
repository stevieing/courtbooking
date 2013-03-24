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

end
