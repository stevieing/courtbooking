class Admin::UsersController < ApplicationController
  
  before_filter :users, only: [:index]
  
  def index
  end
  
  def new
    @manage_user_form = ManageUserForm.new
  end
  
  def create

    @manage_user_form = ManageUserForm.new
     if @manage_user_form.submit(params[:user])
       redirect_to admin_users_path, notice: "User successfully created."
     else
       render :new
     end
  end
  
  def edit
    @manage_user_form = ManageUserForm.new(current_resource)
  end
  
  def update
    @manage_user_form = ManageUserForm.new(current_resource)
    if @manage_user_form.submit(params[:user])
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
