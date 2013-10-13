class Admin::UsersController < ApplicationController
  
  before_filter :users, :only => [:index]
  
  def index
  end
  
  def new
    @user = User.new
    @header = "New user"
  end
  
  def create
    @user = User.new(params[:user])
     if @user.save
       redirect_to admin_users_path, notice: "User successfully created."
     else
       render :new
     end
  end
  
  def edit
    @header = "Edit user"
    @user = current_resource
  end
  
  def update
    @user = current_resource
    params[:user].delete_all(:password, :password_confirmation) if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, notice: "User successfully updated."
    else
      render :edit
    end
  end
  
  def destroy
    @user = current_resource
    if @user.destroy
      notice = "User successfully deleted"
    else
      notice = "Unable to delete user"
    end
    redirect_to admin_users_path, notice: notice
  end

private
  
  def users
    @users ||= User.all
  end
  
  helper_method :users
  
  def current_resource
    @current_resource ||= User.find(params[:id]) if params[:id]
  end

end
