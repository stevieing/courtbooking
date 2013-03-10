require 'spec_helper'

describe User do
  
  it "should not be able to register new users" do
    User.devise_modules.should_not include(:registerable)
  end
  
  describe "valid user" do
    
    before(:each) do
      @user = FactoryGirl.build(:user, username: "value for username", email: "user@email.co.uk", password: "value for password")
    end
    
    it "should be a valid user" do
      @user.should be_valid
    end
    
    it "should have a valid username" do
      @user.username.should_not be_blank
    end
    
    it "should have a valid password" do
      @user.password.should_not be_blank
    end
    
    it "should have a valid email address" do
      @user.email.should_not be_blank
    end
 
  end
end
