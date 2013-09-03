class Admin::UsersController < ApplicationController
  
  before_filter :users, :only => [:index]
  
  def index
  end
  
  def users
    @users ||= User.all
  end
  
  helper_method :users

end
